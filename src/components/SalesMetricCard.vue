<template>
  <div class="sales-metric-card">
    <h5 class="sales-metric-card__title">Продано на суму</h5>

    <!-- Empty State -->
    <div v-if="isEmpty" class="sales-metric-card__empty">
      <div class="empty-state">
        <div class="empty-state__icon">
          <q-icon name="trending_up" size="48px" class="empty-state__icon-inner" />
        </div>
        <h3 class="empty-state__title">Поки що немає продажів</h3>
        <p class="empty-state__message">
          Створіть подію та почніть продавати квитки
        </p>
        <div class="empty-state__actions">
          <q-btn
            label="Додати подію"
            color="secondary"
            unelevated
            @click="handleAddEvent"
            class="empty-state__btn"
          />
          <q-btn
            label="Почати продаж"
            outline
            color="secondary"
            @click="handleStartSales"
            class="empty-state__btn"
          />
        </div>
      </div>
    </div>

    <!-- With Data -->
    <div v-else class="sales-metric-card__content">
      <div class="sales-metric-card__value">
        <span class="sales-metric-card__amount">{{ formattedValue }}</span>
        <span class="sales-metric-card__currency">грн</span>
      </div>
      <a
        href="#"
        class="sales-metric-card__link"
        @click.prevent="handleShowDetails"
      >
        Дізнатись більше
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SalesMetricCard',
  props: {
    value: {
      type: Number,
      default: 0
    },
    details: {
      type: Object,
      default: null
    },
    isEmpty: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    formattedValue () {
      if (!this.value) return '0'
      return this.formatThousands(this.value)
    }
  },
  methods: {
    formatThousands (value) {
      let valArr = value.toString().split('').reverse()
      for (let i = 0; i < valArr.length; i++) {
        if ((i + 1) % 3 === 0 && i < valArr.length - 1) {
          valArr[i + 1] += ' '
        }
      }
      return valArr.reverse().join('')
    },
    handleShowDetails () {
      this.$emit('show-details')
    },
    handleAddEvent () {
      // Navigate to create event page
      this.$router.push('/list-of-events/general')
      this.$emit('add-event')
    },
    handleStartSales () {
      // Navigate to events list
      this.$router.push('/list-of-events/today')
      this.$emit('start-sales')
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.sales-metric-card {
  position: relative;
  width: 100%;
  max-width: 100%;
  padding: $card-padding;
  border-radius: $radius-lg;
  background: $bg-card;
  box-shadow: $card-elevation-3;
  user-select: none;

  &__title {
    @include typography-card-title;
    margin: 0 0 $space-2 0;
    padding: 0;
  }

  &__content {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: $space-2;
  }

  &__value {
    display: flex;
    align-items: baseline;
    gap: $space-1;
  }

  &__amount {
    @include typography-primary-metric;
    font-size: $font-2xl;
  }

  &__currency {
    @include fnt(normal, normal);
    font-size: $font-lg;
    line-height: $line-height-tight;
    color: rgba($primary, 0.7);
    margin-left: $space-1;
  }

  &__link {
    @include typography-label;
    color: $secondary;
    text-decoration: none;
    position: relative;
    padding-bottom: 4px;
    border-bottom: 1px solid rgba($secondary, 0.3);
    transition: all 0.2s ease;

    &:hover, &:active {
      color: lighten($secondary, 10%);
      border-bottom-color: rgba($secondary, 0.5);
      text-decoration: none;
    }
  }

  &__empty {
    padding: $space-4 0;
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: $space-2;

  &__icon {
    margin-bottom: $space-1;
    opacity: 0.8;

    &-inner {
      color: $secondary;
    }
  }

  &__title {
    @include fnt(normal, normal);
    font-size: $font-lg;
    line-height: $line-height-normal;
    color: $text-primary;
    margin: 0;
    padding: 0;
  }

  &__message {
    @include typography-label;
    color: $text-tertiary;
    margin: 0;
    padding: 0;
    max-width: 280px;
  }

  &__actions {
    display: flex;
    flex-direction: column;
    gap: $space-2;
    width: 100%;
    max-width: 280px;
    margin-top: $space-1;
  }

  &__btn {
    width: 100%;
    min-height: 44px; // iOS touch target
  }
}
</style>
