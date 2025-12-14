<template>
  <div class="dashboard-header">
    <img src="../assets/logo.svg" alt="SOLD OUT" class="dashboard-header__logo">
    <div class="dashboard-header__info">
      <h1 class="dashboard-header__title">Статистика</h1>
      <span class="dashboard-header__date">{{ date }}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DashboardHeader',
  props: {
    date: {
      type: String,
      required: true
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.dashboard-header {
  text-align: center;
  margin-bottom: $space-2;
  user-select: none;

  &__logo {
    display: block;
    max-width: 100%;
    height: auto;
    margin: $header-logo-margin-top auto $space-2;
  }

  &__info {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: $header-title-gap;
  }

  &__title {
    @include fnt(300, normal);
    font-size: $font-base;
    line-height: $line-height-tight;
    color: $primary;
    margin: 0;
    padding: 0;
  }

  &__date {
    @include fnt(normal, normal);
    font-size: $font-base;
    line-height: $line-height-tight;
    color: rgba($primary, 0.8);
  }
}
</style>
