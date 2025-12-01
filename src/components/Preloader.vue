<template>
  <div class="preloader">
    <q-spinner size="5rem" color="secondary" :thickness="3"></q-spinner>
  </div>
</template>

<script>
export default {
  name: 'Preloader'
}
</script>

<style lang="scss">
  .preloader {
    display: flex;
    width: 100%;
    height: 100%;
    justify-content: center;
    align-items: center;
    background-color: rgba(#161D31, .68);
    position: fixed;
    z-index: 9999;
  }
</style>
