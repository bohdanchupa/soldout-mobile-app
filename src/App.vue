<template>
  <div id="q-app">
    <preloader v-if="isFetching"></preloader>
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App',
  components: {
    'preloader': () => import('components/Preloader')
  },
  computed: {
    isFetching () {
      return this.$store.getters.isFetchingData
    },
    getUser () {
      return this.$store.getters.getUser
    }
  }
}
</script>

<style lang="scss">
  #q-app {
    background-image: $linear_bg;
  }
</style>
