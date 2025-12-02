import axios from 'axios'
import { epToken, epLogin } from '../../api/endpoints'

// FIXED: Changed from admin-client to sponsor-client (correct credentials from working web app)
// sponsor-client:123456 = c3BvbnNvci1jbGllbnQ6MTIzNDU2
const authorizationBasic = 'Basic c3BvbnNvci1jbGllbnQ6MTIzNDU2'

// Helper function to make HTTP requests (uses Cordova HTTP on mobile, axios on web)
const makeRequest = async (config) => {
  const isCordova = window.cordova !== undefined
  const hasHttpPlugin = isCordova && window.cordova.plugin && window.cordova.plugin.http

  console.log('🔍 HTTP CHECK:', {
    isCordova,
    hasCordovaPlugin: window.cordova?.plugin !== undefined,
    hasHttpPlugin,
    httpPlugin: window.cordova?.plugin?.http
  })

  if (hasHttpPlugin) {
    console.log('📱 Using Cordova Native HTTP Plugin')
    const http = window.cordova.plugin.http

    try {
      // Build URL with params
      let url = config.url
      if (config.params) {
        const params = new URLSearchParams(config.params).toString()
        url = `${url}?${params}`
      }

      const headers = config.headers || {}
      const method = config.method.toLowerCase()

      // Set data serializer
      http.setDataSerializer('utf8')

      let response
      if (method === 'post') {
        response = await new Promise((resolve, reject) => {
          http.sendRequest(url, { method: 'post', data: {}, headers: headers }, resolve, reject)
        })
      } else if (method === 'get') {
        response = await new Promise((resolve, reject) => {
          http.sendRequest(url, { method: 'get', headers: headers }, resolve, reject)
        })
      }

      // Parse response
      const data = typeof response.data === 'string' ? JSON.parse(response.data) : response.data
      return { data }
    } catch (error) {
      console.error('❌ Cordova HTTP Error:', error)
      const err = new Error(error.error || 'Network Error')
      err.response = { status: error.status, data: error.error }
      throw err
    }
  } else {
    console.log('🌐 Using Axios (Web)')
    console.log('  Axios Request Config:', JSON.stringify(config, null, 2))

    try {
      const response = await axios(config)
      console.log('✅ Axios Response Success:', {
        status: response.status,
        statusText: response.statusText,
        data: response.data
      })
      return response
    } catch (axiosError) {
      console.error('❌ Axios Request Failed!')
      console.error('  URL:', config.url)
      console.error('  Method:', config.method)
      console.error('  Error:', axiosError.message)
      console.error('  Response Status:', axiosError.response?.status)
      console.error('  Response Data:', axiosError.response?.data)
      console.error('  Response Headers:', axiosError.response?.headers)
      throw axiosError
    }
  }
}

export const login = async ({ commit }, { login, password }) => {
  const requestConfig = {
    method: 'post',
    url: epToken,
    params: {
      username: login,
      password: password,
      grant_type: 'password'
    },
    headers: {
      'Authorization': authorizationBasic
    }
  }

  console.log('🔐 LOGIN ATTEMPT:')
  console.log('  URL:', epToken)
  console.log('  Method:', requestConfig.method)
  console.log('  Username:', login)
  console.log('  Auth Header:', authorizationBasic)
  console.log('  All Headers:', JSON.stringify(requestConfig.headers, null, 2))
  console.log('  Params:', JSON.stringify(requestConfig.params, null, 2))
  console.log('  isCordova:', window.cordova !== undefined)
  console.log('  Full URL with params:', `${epToken}?username=${login}&password=${password}&grant_type=password`)

  try {
    const tokenResponse = await makeRequest(requestConfig)

    console.log('✅ TOKEN RESPONSE:', tokenResponse.data)
    const accessToken = tokenResponse.data.access_token
    console.log('👤 FETCHING USER INFO:', epLogin)

    const userResponse = await makeRequest({
      method: 'get',
      url: epLogin,
      headers: {
        'Authorization': 'Bearer  ' + accessToken
      }
    })

    console.log('✅ USER INFO:', userResponse.data)
    const firstName = userResponse.data.firstName
    const lastName = userResponse.data.lastName
    const mail = userResponse.data.mail
    const phone = userResponse.data.phone

    // NOTE: Credentials are now saved in Login.vue based on "Remember me" checkbox
    // LocalStorage.set('userData', {...}) - moved to Login.vue

    // Clear any previous errors
    commit('setError', { error: null })

    commit('login', { accessToken, firstName, lastName, mail, phone })
  } catch (err) {
    console.error('❌ ====== LOGIN ERROR DETAILS ======')
    console.error('Error Message:', err.message)
    console.error('Error Name:', err.name)
    console.error('Error Stack:', err.stack)
    console.error('')
    console.error('--- Response Info ---')
    console.error('Status Code:', err.response?.status)
    console.error('Status Text:', err.response?.statusText)
    console.error('Response Data:', err.response?.data)
    console.error('Response Headers:', err.response?.headers)
    console.error('')
    console.error('--- Request Info ---')
    console.error('Request URL:', err.config?.url)
    console.error('Request Method:', err.config?.method)
    console.error('Request Headers:', err.config?.headers)
    console.error('Request Params:', err.config?.params)
    console.error('')
    console.error('--- Full Error Object ---')
    console.error(JSON.stringify(err, Object.getOwnPropertyNames(err), 2))
    console.error('===================================')
    
    // Store error info for UI
    commit('setError', { 
      error: {
        status: err.response?.status,
        message: err.message,
        data: err.response?.data,
        url: err.config?.url
      }
    })
    
    // DON'T throw - let Login.vue handle the error via getAccessToken check
    return null
  }
}

export const logout = ({ commit }) => {
  commit('logout')
}

export const showDetails = ({ commit }, { show }) => {
  commit('showDetails', { show })
}

export const setDateForDetails = ({ commit }, { date }) => {
  commit('setDateForDetails', { date })
}

export const fetchingData = ({ commit }, { isFetching }) => {
  commit('fetchingData', { isFetching })
}
