<template>
  <q-page class="page page--profile content flex flex-center">
    <q-header class="header">
      <router-link to="/entry">Мій профіль</router-link>
    </q-header>
    <div class="container">
      <ul class="profile-inf">
        <li>
          <h4>Логін:</h4>
          <h3>{{login}}</h3>
        </li>
        <li>
          <h4>Електронна пошта:</h4>
          <h3>{{email}}</h3>
        </li>
        <li>
          <h4>Телефон:</h4>
          <h3>{{phone}}</h3>
        </li>
      </ul>
      <div class="text-right">
        <a href="#" class="logout-btn" @click.prevent="logout">Вийти</a>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: 'Profile',
  computed: {
    login () {
      return this.$store.getters.getUser.mail
    },
    email () {
      return this.$store.getters.getUser.mail
    },
    phone () {
      return this.$store.getters.getUser.phone
    }
  },
  methods: {
    logout () {
      console.log('🚪 Logging out...')
      
      // Clear Vuex store
      this.$store.dispatch('logout')
      
      // Clear ALL localStorage data
      this.$q.localStorage.remove('userData')
      this.$q.localStorage.remove('savedAuth')
      this.$q.localStorage.remove('rememberMe')
      
      console.log('✓ All saved data cleared')
      
      // Redirect to login
      this.$router.replace('/')
    }
  }
}
</script>

<style lang="scss">
  @import '../css/quasar.variables';
  .profile-inf {
    list-style: none;
    margin: 0 auto;
    padding: 0;
    width: 306px;
    li {
      display: block;
      padding: 18px 10px 10px;
      border-bottom: 1px solid #15213C;
      h3, h4 {
        @include fnt(normal, normal);
        font-size: 12px;
        line-height: 12px;
        color: #141B2C;
        margin: 0;
        padding: 0;
      }
      h4 {
        margin-bottom: 6px;
      }
      h3 {
        font-weight: 500;
        color: $primary;
        font-size: 14px;
        line-height: 14px;
      }
    }
  }
  .logout-btn {
    display: inline-block;
    outline: none;
    @include fnt(normal, normal);
    font-size: 16px;
    color: $secondary;
    margin-top: 32px;
    padding: 0;
    text-decoration: none;
  }
</style>
