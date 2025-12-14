<template>
  <div class="kpi-card" :class="{ 'kpi-card--empty': isEmpty }">
    <div class="kpi-card__icon" v-if="icon" :style="{ color: iconColor }">
      <q-icon :name="icon" size="24px" class="kpi-card__icon-inner" />
    </div>
    <div class="kpi-card__value">
      <span class="kpi-card__number">{{ formattedValue }}</span>
    </div>
    <div class="kpi-card__label">{{ label }}</div>
    <div v-if="isEmpty && showEmptyHint" class="kpi-card__hint">
      Поки що немає
    </div>
  </div>
</template>

<script>
export default {
  name: 'KpiCard',
  props: {
    icon: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      required: true
    },
    value: {
      type: Number,
      default: 0
    },
    isEmpty: {
      type: Boolean,
      default: false
    },
    showEmptyHint: {
      type: Boolean,
      default: true
    },
    iconColor: {
      type: String,
      default: 'secondary'
    }
  },
  computed: {
    formattedValue () {
      return this.value || 0
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.kpi-card {
  position: relative;
  padding: $kpi-card-padding;
  border-radius: $radius-md;
  background: $bg-card;
  box-shadow: $card-elevation-1;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: $space-1;
  user-select: none;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.98);
    background: $bg-card-hover;
  }

  &__icon {
    margin-bottom: $space-1;
    opacity: 0.9;

    &-inner {
      color: inherit;
    }
  }

  &__value {
    margin: $space-1 0;
  }

  &__number {
    @include typography-kpi-value;
    display: block;
  }

  &__label {
    @include typography-card-title;
    margin-top: $space-1;
  }

  &__hint {
    @include typography-label;
    font-size: 10px;
    margin-top: $space-1;
    opacity: 0.5;
  }

  &--empty {
    .kpi-card__number {
      opacity: 0.6;
    }
  }
}
</style>
