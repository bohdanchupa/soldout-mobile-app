<template>
  <q-page class="page page--login content flex flex-center">
    <q-page-container>
      <div class="login-form">
        <img src="../assets/logo.svg" alt="logo">
        <form @submit.prevent="login">
          <div>
            <label for="email">Електронна пошта:</label>
            <input type="email" v-model="email" id="email">
          </div>
          <div>
            <label for="pass">Пароль:</label>
            <input type="password" v-model="pass" id="pass">
          </div>
          <div class="error-msg" v-if="showError">
            <p>{{errorMsg}}</p>
          </div>
          <button type="submit">Увійти</button>
        </form>
      </div>
    </q-page-container>
  </q-page>
</template>

<script>
/*
* d.crosspost@gmail.com
* aXLYjbfTNNN_soldout584
*
* tomkevicho99@ukr.net
* Test123Test123
* */

export default {
  name: 'Login',
  data () {
    return {
      email: '',
      pass: '',
      isUser: false,
      showError: false,
      errorMsg: 'Щось пішло не так! Перевірте введені Вами дані'
    }
  },
  created () {
    let storageData = this.$q.localStorage.getItem('userData')
    if (storageData.login && storageData.pass) {
      this.email = storageData.login
      this.pass = storageData.pass
      this.login()
    }
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
  },
  methods: {
    login () {
      this.$store.dispatch('fetchingData', { isFetching: true })
      this.$store.dispatch('login', { 'login': this.email, 'password': this.pass }).then(() => {
        setTimeout(() => {
          if (!this.$store.getters.getAccessToken) {
            this.showError = true
          } else {
            this.showError = false
            this.$router.push({
              path: '/entry'
            })
          }
          this.$store.dispatch('fetchingData', { isFetching: false })
        }, 1000)
      })
    }
  }
}
</script>

<style lang="scss">
  .error-msg {
    max-width: 80%;
    margin: 10px auto;
    text-align: center;
    color: #FD3363;
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
