<template>
  <div class="chart-card">
    <div class="chart-card__header">
      <h3 class="chart-card__title">Динаміка за 7 днів</h3>
      <div class="chart-card__legend" v-if="hasData">
        <div
          class="chart-legend-item"
          v-for="(item, idx) in legendItems"
          :key="idx"
          :class="{ 'chart-legend-item--active': activeLegend === idx }"
          @click="handleLegendClick(idx)"
        >
          <span
            class="chart-legend-item__dot"
            :style="{ backgroundColor: item.color }"
          ></span>
          <span class="chart-legend-item__label">{{ item.label }}</span>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!hasData" class="chart-card__empty">
      <div class="empty-state empty-state--compact">
        <div class="empty-state__icon">
          <q-icon name="show_chart" size="40px" class="empty-state__icon-inner" />
        </div>
        <h4 class="empty-state__title">Немає даних для відображення</h4>
        <p class="empty-state__message">
          Дані з'являться після перших продажів
        </p>
      </div>
    </div>

    <!-- Chart with Data -->
    <div v-else class="chart-card__content">
      <sine-charts
        :charts="charts"
        @marker-click="handleMarkerClick"
        class="chart-card__chart"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChartCard',
  components: {
    'sine-charts': () => import('./SineCharts')
  },
  props: {
    charts: {
      type: Array,
      default: () => []
    },
    hasData: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      activeLegend: -1,
      legendItems: [
        { label: 'Квитки', color: '#12BFFF' },
        { label: 'Замовлено', color: '#FF608E' },
        { label: 'Сума', color: '#66E8CD' }
      ]
    }
  },
  methods: {
    handleLegendClick (index) {
      this.activeLegend = this.activeLegend === index ? -1 : index
      this.$emit('legend-toggle', index)
    },
    handleMarkerClick (data) {
      this.$emit('marker-click', data)
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.chart-card {
  position: relative;
  width: 100%;
  padding: $card-padding;
  border-radius: $radius-md;
  background: $bg-card;
  box-shadow: $card-elevation-2;
  user-select: none;

  &__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: $space-2;
    flex-wrap: wrap;
    gap: $space-2;
  }

  &__title {
    @include typography-card-title;
    margin: 0;
    padding: 0;
  }

  &__legend {
    display: flex;
    gap: $space-2;
    flex-wrap: wrap;
  }

  &__content {
    width: 100%;
    overflow-x: auto;
  }

  &__chart {
    width: 100%;
    min-height: 180px;
  }

  &__empty {
    padding: $space-5 0;
  }
}

.chart-legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 12px;
  transition: all 0.2s ease;

  &:hover {
    background: rgba($primary, 0.1);
  }

  &--active {
    background: rgba($primary, 0.15);
  }

  &__dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: block;
    flex-shrink: 0;
  }

  &__label {
    @include typography-label;
    font-size: 11px;
    white-space: nowrap;
  }
}

.empty-state--compact {
  gap: $space-1;
  padding: 0;

  .empty-state__icon {
    margin-bottom: 0;
    opacity: 0.6;

    &-inner {
      color: $secondary;
    }
  }

  .empty-state__title {
    font-size: $font-base;
    margin-bottom: $space-1;
  }

  .empty-state__message {
    font-size: 11px;
    max-width: 240px;
  }
}
</style>
