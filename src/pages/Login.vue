<template>
  <q-page class="page page--login content flex flex-center">
    <q-page-container>
      <div class="login-form">
        <img src="../assets/logo.svg" alt="logo">
        <form @submit.prevent="login">
          <div>
            <label for="email">Електронна пошта:</label>
            <input type="email" v-model="email" id="email" required>
          </div>
          <div>
            <label for="pass">Пароль:</label>
            <input type="password" v-model="pass" id="pass" required>
          </div>
          <div class="remember-me-container">
            <label class="remember-me-label">
              <div class="custom-checkbox-wrapper">
                <input
                  type="checkbox"
                  v-model="rememberMe"
                  class="remember-me-checkbox"
                  id="remember-checkbox"
                >
                <span class="custom-checkbox"></span>
              </div>
              <span class="remember-me-text">Запам'ятати мене</span>
            </label>
          </div>
          <div class="error-msg" v-if="showError">
            <p>{{errorMsg}}</p>
          </div>
          <div class="success-msg" v-if="showSuccess">
            <p>✓ Вхід виконано успішно!</p>
          </div>
          <button type="submit">Увійти</button>
        </form>
      </div>
    </q-page-container>
  </q-page>
</template>

<script>
/*
* Основні credentials (PROD):
* romanchupa1@gmail.com
* sJAk969beho_
* */

export default {
  name: 'Login',
  data () {
    return {
      email: '',
      pass: '',
      rememberMe: true,
      isUser: false,
      showError: false,
      showSuccess: false,
      errorMsg: 'Щось пішло не так! Перевірте введені Вами дані'
    }
  },
  created () {
    console.log('🔍 Login page created')

    // Check if user was logged in with "Remember me"
    const rememberMeEnabled = this.$q.localStorage.getItem('rememberMe')
    const savedAuth = this.$q.localStorage.getItem('savedAuth')

    if (rememberMeEnabled && savedAuth && savedAuth.accessToken) {
      console.log('✅ Found saved session - auto-login')
      // Restore auth state from localStorage
      this.$store.commit('login', {
        accessToken: savedAuth.accessToken,
        firstName: savedAuth.firstName,
        lastName: savedAuth.lastName,
        mail: savedAuth.mail,
        phone: savedAuth.phone
      })
      // Redirect immediately
      this.$router.push({ path: '/entry' })
      return
    }

    // No saved session - show login form
    const savedData = this.$q.localStorage.getItem('userData')

    if (rememberMeEnabled && savedData && savedData.login && savedData.pass) {
      this.email = savedData.login
      this.pass = savedData.pass
      this.rememberMe = true
      console.log('✓ Loaded saved credentials')
    } else {
      // Use default PROD credentials for first time
      this.email = 'romanchupa1@gmail.com'
      this.pass = 'sJAk969beho_'
      console.log('📝 Using default credentials')
    }

    // Watch for successful login to redirect
    this.$store.watch(
      (state, getters) => getters.getAccessToken,
      (newValue, oldValue) => {
        if (newValue) {
          this.$router.push({
            path: '/entry'
          })
        }
      }
    )
  },
  mounted () {
    this.$store.dispatch('fetchingData', { isFetching: false })
    if (this.$store.getters.getAccessToken) {
      this.showError = false
      this.$router.push({
        path: '/entry'
      })
    }

    // Listen for Cordova deviceready event
    if (window.cordova) {
      document.addEventListener('deviceready', () => {
        console.log('✅ Cordova deviceready event fired!')
        console.log('📱 Cordova plugins available:', window.cordova.plugin)
      }, false)
    } else {
      console.log('⚠️ Running in browser mode (no Cordova)')
    }
  },
  methods: {
    login () {
      console.log('🔐 Login button clicked')
      this.showError = false
      this.showSuccess = false

      // Save "Remember me" preference
      if (this.rememberMe) {
        this.$q.localStorage.set('rememberMe', true)
        console.log('✓ Remember me enabled')
      } else {
        this.$q.localStorage.remove('rememberMe')
        this.$q.localStorage.remove('userData')
        this.$q.localStorage.remove('savedAuth')
        console.log('✗ Remember me disabled - all saved data cleared')
      }

      this.$store.dispatch('fetchingData', { isFetching: true })

      this.$store.dispatch('login', { 'login': this.email, 'password': this.pass }).then(() => {
        // Check multiple times for better UX
        const checkAuth = () => {
          if (this.$store.getters.getAccessToken) {
            console.log('✅ Login successful!')
            this.showError = false
            this.showSuccess = true

            // Save credentials and auth state if "Remember me" is checked
            if (this.rememberMe) {
              // Save credentials for login form
              this.$q.localStorage.set('userData', {
                'login': this.email,
                'pass': this.pass
              })
              
              // Save full auth state for auto-login
              const user = this.$store.getters.getUser
              this.$q.localStorage.set('savedAuth', {
                'accessToken': this.$store.getters.getAccessToken,
                'firstName': user.firstName,
                'lastName': user.lastName,
                'mail': user.mail,
                'phone': user.phone
              })
              console.log('✓ Credentials and auth state saved for next time')
            }

            // Show success message briefly before redirect
            setTimeout(() => {
              this.$store.dispatch('fetchingData', { isFetching: false })
              this.$router.push({
                path: '/entry'
              })
            }, 300)
          } else {
            console.log('⚠️ No token yet, checking again...')
          }
        }

        // Check immediately
        setTimeout(checkAuth, 100)

        // Check again after 500ms
        setTimeout(checkAuth, 500)

        // Final check after 1 second
        setTimeout(() => {
          if (!this.$store.getters.getAccessToken) {
            console.error('❌ Login failed - no token received')

            // Try to get detailed error from store
            const storeError = this.$store.getters.getError
            if (storeError && storeError.status) {
              if (storeError.status === 403) {
                this.errorMsg = 'Доступ заборонено (403). Перевірте CORS налаштування на сервері.'
              } else if (storeError.status === 401) {
                this.errorMsg = 'Невірний логін або пароль'
              } else if (storeError.data && storeError.data.error_description) {
                this.errorMsg = storeError.data.error_description
              } else {
                this.errorMsg = `Помилка ${storeError.status}: ${storeError.message}`
              }
              console.error('Error details:', storeError)
            }

            this.showError = true
            this.showSuccess = false
            this.$store.dispatch('fetchingData', { isFetching: false })
          }
        }, 1000)
      }).catch((err) => {
        console.error('❌ Login promise rejected:', err)
        this.showError = true
        this.showSuccess = false
        this.$store.dispatch('fetchingData', { isFetching: false })
      })
    }
  }
}
</script>

<style lang="scss">
  .remember-me-container {
    margin-top: 16px;
    padding-left: 20px;
    display: flex;
    align-items: center;
  }

  .remember-me-label {
    display: flex;
    align-items: center;
    cursor: pointer;
    user-select: none;
  }

  .custom-checkbox-wrapper {
    position: relative;
    display: inline-block;
    margin-right: 10px;
  }

  .remember-me-checkbox {
    position: absolute;
    opacity: 0;
    cursor: pointer;
    width: 18px;
    height: 18px;
    z-index: 1;
  }

  .custom-checkbox {
    display: inline-block;
    width: 18px;
    height: 18px;
    border: 1.5px solid rgba(255, 255, 255, 0.3);
    border-radius: 3px;
    background-color: transparent;
    transition: all 0.2s ease;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      display: none;
      left: 5px;
      top: 2px;
      width: 5px;
      height: 9px;
      border: solid white;
      border-width: 0 2px 2px 0;
      transform: rotate(45deg);
    }
  }

  .remember-me-checkbox:checked ~ .custom-checkbox {
    background-color: #FD3363;
    border-color: #FD3363;

    &::after {
      display: block;
    }
  }

  .remember-me-checkbox:hover ~ .custom-checkbox {
    border-color: rgba(255, 255, 255, 0.5);
  }

  .remember-me-text {
    @include fnt(normal, normal);
    font-size: 14px;
    line-height: 20px;
    color: rgba(255, 255, 255, 0.8);
  }

  .error-msg {
    max-width: 80%;
    margin: 10px auto;
    text-align: center;
    color: #FD3363;
    animation: fadeIn 0.3s ease;
  }

  .success-msg {
    max-width: 80%;
    margin: 10px auto;
    text-align: center;
    color: #4CAF50;
    font-weight: 500;
    animation: fadeIn 0.3s ease;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(-5px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  .login-form {
    margin-top: 120px;
    img {
      width: 176px;
      height: auto;
    }
    form {
      margin-top: 34px;
      div {
        margin-top: 16px;
        &:first-child {
          margin-top: 0;
        }
      }
      label, input {
        display: block;
      }
      label {
        padding-left: 20px;
        @include fnt(normal, normal);
        font-size: 12px;
        line-height: 21px;
        color: $dark-text-color;
        user-select: none;
      }
      input {
        padding: 0 20px;
        outline: none;
        width: 303px;
        height: 40px;
        background-color: transparent;
        border: 1px solid $form-border-unactive;
        border-radius: 20px;
        @include fnt(normal, normal);
        font-size: 14px;
        color: $primary;
        transition: border-color .3s ease-in-out;
        &:focus {
          border-color: $form-border-active;
        }
      }
      button {
        display: block;
        width: 141px;
        height: 40px;
        border-radius: 20px;
        border: none;
        background-color: transparent;
        background-image: $linear_submit-btn;
        margin: 30px 0 0 auto;
        @include fnt(normal, normal);
        font-size: 14px;
        color: $primary;
        outline: none;
        user-select: none;
      }
    }
  }
</style>
