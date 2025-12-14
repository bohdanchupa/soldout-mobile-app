<template>
  <div class="kpi-grid">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'KpiGrid'
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.kpi-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: $kpi-grid-gap;
  width: 100%;
}
</style>
