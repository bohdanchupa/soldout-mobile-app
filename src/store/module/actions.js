import axios from 'axios'
import { epToken, epLogin } from '../../api/endpoints'
import { LocalStorage } from 'quasar'

const authorizationBasic = 'Basic  YWRtaW4tY2xpZW50OjEyMzQ1Ng=='

export const login = async ({ commit }, { login, password }) => {
  await axios({
    method: 'post',
    url: epToken,
    params: {
      username: login,
      password: password,
      grant_type: 'password'
    },
    headers: {
      'Authorization': authorizationBasic,
      'X-SOLDOUT-STATISTIC-APP-ACCESS': 'b9011a8e5cdb1b62ec5513e2303c2b78'
    }
  }).then((data) => {
    let accessToken = data.data.access_token
    axios({
      method: 'get',
      url: epLogin,
      headers: {
        'Authorization': 'Bearer  ' + accessToken,
        'X-SOLDOUT-STATISTIC-APP-ACCESS': 'b9011a8e5cdb1b62ec5513e2303c2b78'
      }
    }).then((data) => {
      let firstName = data.data.firstName
      let lastName = data.data.lastName
      let mail = data.data.mail
      let phone = data.data.phone
      LocalStorage.set('userData', {
        'login': login,
        'pass': password
      })
      commit('login', { accessToken, firstName, lastName, mail, phone })
    })
  }).catch(err => {
    console.log(err.message)
  })
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
