// Cordova initialization and diagnostics

export default async ({ app, router, store, Vue }) => {
  console.log('🔧 BOOT: Cordova boot file loaded')
  console.log('🔍 window.cordova:', window.cordova)
  console.log('🔍 document.readyState:', document.readyState)

  // Get iPhone IP address
  console.log('📱 ====== NETWORK INFO ======')
  console.log('User Agent:', navigator.userAgent)
  console.log('Platform:', navigator.platform)
  console.log('Language:', navigator.language)
  console.log('Online:', navigator.onLine)
  console.log('Connection:', navigator.connection)

  // Try to get local IP via WebRTC
  try {
    const pc = new RTCPeerConnection({ iceServers: [] })
    pc.createDataChannel('')
    pc.createOffer().then(offer => pc.setLocalDescription(offer))
    pc.onicecandidate = ice => {
      if (!ice || !ice.candidate || !ice.candidate.candidate) return
      const ipRegex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/
      const ipMatch = ipRegex.exec(ice.candidate.candidate)
      if (ipMatch) {
        console.log('📱 iPhone IP Address (WebRTC):', ipMatch[1])
        pc.onicecandidate = () => {}
        pc.close()
      }
    }
  } catch (e) {
    console.log('⚠️ Could not get IP via WebRTC:', e.message)
  }
  console.log('==============================')

  if (window.cordova) {
    console.log('📱 Cordova detected! Waiting for deviceready...')

    // Listen for deviceready
    document.addEventListener('deviceready', () => {
      console.log('✅ ✅ ✅ DEVICEREADY EVENT FIRED! ✅ ✅ ✅')
      console.log('📱 window.cordova:', window.cordova)
      console.log('📱 window.cordova.plugin:', window.cordova.plugin)
      console.log('📱 window.cordova.plugins:', window.cordova.plugins)

      if (window.cordova.plugin && window.cordova.plugin.http) {
        console.log('✅ HTTP Plugin available:', window.cordova.plugin.http)
      } else {
        console.error('❌ HTTP Plugin NOT available!')
        console.log('Available plugins:', Object.keys(window.cordova.plugins || {}))
      }
    }, false)

    // Timeout warning
    setTimeout(() => {
      if (!window.hasDeviceReady) {
        console.error('⚠️ WARNING: deviceready did not fire within 5 seconds!')
        console.log('This might indicate a Cordova initialization problem')
      }
    }, 5000)
  } else {
    console.log('🌐 Running in browser mode (no Cordova)')
  }
}

