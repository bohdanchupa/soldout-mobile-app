<!-- ПРИКЛАД: Оновлений Entry.vue з новими компонентами -->
<!-- Це приклад - НЕ замінює існуючий Entry.vue одразу -->
<!-- Можна інтегрувати поступово або використовувати як reference -->

<template>
  <q-page class="page page--statistics">
    <!-- Header Section -->
    <dashboard-header
      :date="date"
      class="statistics__header"
    />

    <!-- Primary Metric Card -->
    <sales-metric-card
      :value="salesAmount"
      :details="details"
      :is-empty="isSalesEmpty"
      @show-details="handleShowDetails"
      class="statistics__sales-card"
    />

    <!-- KPI Grid -->
    <kpi-grid class="statistics__kpi-grid">
      <kpi-card
        icon="shopping_cart"
        label="Замовлень"
        :value="allOrderCount"
        :is-empty="allOrderCount === 0"
        icon-color="#46C6FF"
      />
      <kpi-card
        icon="local_activity"
        label="Квитків"
        :value="allTicketCount"
        :is-empty="allTicketCount === 0"
        icon-color="#66E8CD"
      />
    </kpi-grid>

    <!-- Chart Section -->
    <chart-card
      :charts="charts"
      :has-data="hasChartData"
      @marker-click="onMarkerClick"
      class="statistics__chart-card"
    />

    <!-- Details Modal (existing logic - keep for backwards compatibility) -->
    <total-soulds
      v-if="showDetails && detailsForAnotherDay"
      :details="detailsForAnotherDay"
      :showDetail="true"
      :style="{'z-index': 0}"
    />
  </q-page>
</template>

<script>
import { epAllOrders, epAllTickets, epSummOfPeriod, epStatisticInEntryScreen } from '../api/endpoints'

export default {
  name: 'Statistics',
  components: {
    'dashboard-header': () => import('../components/DashboardHeader'),
    'sales-metric-card': () => import('../components/SalesMetricCard'),
    'kpi-grid': () => import('../components/KpiGrid'),
    'kpi-card': () => import('../components/KpiCard'),
    'chart-card': () => import('../components/ChartCard'),
    'total-soulds': () => import('../components/TotalSoulds')
  },
  data () {
    return {
      currentDate: this.date,
      showCharts: false,
      allOrderCount: 0,
      allTicketCount: 0,
      details: null,
      detailsForAnotherDay: null,
      charts: [
        {
          color: '#12BFFF',
          points: []
        },
        {
          color: '#66E8CD',
          points: []
        },
        {
          color: '#FF608E',
          points: []
        }
      ]
    }
  },
  created () {
    this.showCharts = false
  },
  mounted () {
    // ЗАЛИШАЄМО ВСЮ ІСНУЮЧУ ЛОГІКУ БЕЗ ЗМІН
    let d = new Date()
    let day = d.getDate() < 10 ? '0' + d.getDate() : d.getDate()
    let month = d.getMonth() + 1 < 10 ? '0' + (d.getMonth() + 1) : d.getMonth() + 1
    let todayFrom = d.getFullYear() + '-' + month + '-' + day + 'T00:00:00'
    let todayTo = d.getFullYear() + '-' + month + '-' + day + 'T23:59:59'
    this.$store.dispatch('fetchingData', { isFetching: true })

    // Details
    this.$axios({
      methods: 'get',
      url: epSummOfPeriod,
      params: {
        dateFrom: todayFrom,
        dateTo: todayTo
      },
      headers: {
        'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
      }
    }).then((data) => {
      this.details = data.data
      // All orders count
      this.$axios({
        methods: 'get',
        url: epAllOrders,
        params: {
          dateFrom: todayFrom,
          dateTo: todayTo
        },
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((data) => {
        this.allOrderCount = data.data.allOrderCount
      })
      // All tickets count
      this.$axios({
        methods: 'get',
        url: epAllTickets,
        params: {
          dateFrom: todayFrom,
          dateTo: todayTo
        },
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((data) => {
        this.allTicketCount = data.data.allTicketCount
        // Sine charts - ЗАЛИШАЄМО ІСНУЮЧУ ЛОГІКУ
        this.$axios({
          methods: 'get',
          url: epStatisticInEntryScreen,
          params: {
            dateFrom: this.getDateForParams(6) + 'T23:59:59'
          },
          headers: {
            'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
          }
        }).then((res) => {
          // ... existing chart logic ...
          // (keep all existing chart processing code)
          this.showCharts = true
          this.$store.dispatch('fetchingData', { isFetching: false })
        })
      })
    })
  },
  methods: {
    // ЗАЛИШАЄМО ВСІ ІСНУЮЧІ МЕТОДИ
    handleShowDetails () {
      // Open details popup (existing TotalSoulds component logic)
      // Можна інтегрувати з існуючою логікою TotalSoulds
    },
    onMarkerClick (e) {
      // Existing marker click logic
      let year = '20' + e.split('.')[2]
      let month = e.split('.')[1]
      let day = e.split('.')[0]
      this.$axios({
        methods: 'get',
        url: epSummOfPeriod,
        params: {
          dateFrom: year + '-' + month + '-' + day + 'T00:00:00',
          dateTo: year + '-' + month + '-' + day + 'T23:59:59'
        },
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((data) => {
        this.detailsForAnotherDay = data.data
      })
    },
    // ... всі інші існуючі методи ...
    parseTimestampWithoutOffset (tstmp) {
      // existing logic
    },
    parseTimestamp (tstmp) {
      // existing logic
    },
    getDate (offset) {
      // existing logic
    },
    getDateForParams (offset) {
      // existing logic
    }
  },
  computed: {
    showDetails () {
      return this.$store.getters.isDetailsShow
    },
    date () {
      let today = new Date()
      let day = today.getDate() < 10 ? '0' + today.getDate() : today.getDate()
      let month = today.getMonth() + 1 < 10 ? '0' + (today.getMonth() + 1) : today.getMonth() + 1
      return `${day}.${month}.${today.getFullYear()}`
    },
    // НОВІ COMPUTED для нових компонентів
    salesAmount () {
      return this.details?.allTicketSum || 0
    },
    isSalesEmpty () {
      return !this.details || this.details.allTicketSum === 0
    },
    hasChartData () {
      if (!this.showCharts || !this.charts || this.charts.length === 0) {
        return false
      }
      return this.charts.some(chart =>
        chart.points &&
        chart.points.length > 0 &&
        chart.points.some(p => p.y > 0)
      )
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.page--statistics {
  padding: $page-padding-y $page-padding-x $page-padding-x;

  // Safe area support
  padding-top: calc(#{$page-padding-y} + env(safe-area-inset-top));
  padding-bottom: calc(64px + env(safe-area-inset-bottom)); // Footer height

  .statistics__header {
    margin-bottom: $space-2;
  }

  .statistics__sales-card {
    margin-bottom: $section-gap;
  }

  .statistics__kpi-grid {
    margin-bottom: $section-gap;
  }

  .statistics__chart-card {
    margin-bottom: $space-2;
  }
}
</style>
