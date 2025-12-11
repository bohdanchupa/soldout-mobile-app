<template>
  <q-page class="page page--today content flex flex-center">
    <div>
      <img src="../assets/logo.svg" alt="logo" class="logo">
      <div class="date">
        <h4>Статистика</h4>
        <span>{{date}}</span>
      </div>
      <total-soulds v-if="details" :details="details"/>
      <div class="charts-container" v-if="showCharts">
        <sine-charts class="charts" :charts="charts" @marker-click="onMarkerClick"/>
      </div>
      <total-soulds v-if="showDetails && detailsForAnotherDay" :details="detailsForAnotherDay" :showDetail="true" :style="{'z-index': 0}"/>
      <div class="today-total-inf">
        <div>
          <h2>{{allOrderCount}}</h2>
          <span class="divider-3"></span>
          <h4>Замовлень</h4>
        </div>
        <div>
          <h2>{{allTicketCount}}</h2>
          <span class="divider-4"></span>
          <h4>Квитків</h4>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script>
import { epAllOrders, epAllTickets, epSummOfPeriod, epStatisticInEntryScreen } from '../api/endpoints'

export default {
  name: 'Today',
  components: {
    'total-soulds': () => import('../components/TotalSoulds'),
    'sine-charts': () => import('../components/SineCharts')
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
        // Sine charts
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
          let data = res.data
          this.charts[0].points = []
          this.charts[1].points = []
          this.charts[2].points = []
          let maxSoldTicket = this.allTicketCount
          let maxBookedTickets = this.allOrderCount
          let maxTicketMoney = this.details.allTicketSum
          for (let i = 0; i < data.length; i++) {
            if (data[i].soldTickets > maxSoldTicket) maxSoldTicket = data[i].soldTickets
            if (data[i].bookedTickets > maxBookedTickets) maxBookedTickets = data[i].bookedTickets
            if (data[i].soldTicketMoney > maxTicketMoney) maxTicketMoney = data[i].soldTicketMoney
          }
          for (let i = 0; i < data.length; i++) {
            let currentOffsetDay = this.parseTimestamp(data[i].statisticDayTimestamp)
            let tickets = isNaN(data[i].soldTickets * 100 / maxSoldTicket) ? 0 : data[i].soldTickets * 100 / maxSoldTicket
            let orders = isNaN(data[i].bookedTickets * 100 / maxBookedTickets) ? 0 : data[i].bookedTickets * 100 / maxBookedTickets
            let sum = isNaN(data[i].soldTicketMoney * 100 / maxTicketMoney) ? 0 : data[i].soldTicketMoney * 100 / maxTicketMoney
            this.charts[0].points.push({
              x: currentOffsetDay,
              y: tickets
            })
            this.charts[1].points.push({
              x: currentOffsetDay,
              y: orders
            })
            this.charts[2].points.push({
              x: currentOffsetDay,
              y: sum
            })
            if (i === 0) {
              this.charts[0].points.push({
                x: currentOffsetDay,
                y: tickets
              })
              this.charts[1].points.push({
                x: currentOffsetDay,
                y: orders
              })
              this.charts[2].points.push({
                x: currentOffsetDay,
                y: sum
              })
            }
          }
          // Today information
          let currentOffsetDay = this.parseTimestampWithoutOffset(todayTo)
          let tickets = isNaN(this.allTicketCount * 100 / maxSoldTicket) ? 0 : this.allTicketCount * 100 / maxSoldTicket
          let orders = isNaN(this.allOrderCount * 100 / maxBookedTickets) ? 0 : this.allOrderCount * 100 / maxBookedTickets
          let sum = isNaN(this.details.allTicketSum * 100 / maxTicketMoney) ? 0 : this.details.allTicketSum * 100 / maxTicketMoney
          this.charts[0].points.push({
            x: currentOffsetDay,
            y: tickets
          })
          this.charts[1].points.push({
            x: currentOffsetDay,
            y: orders
          })
          this.charts[2].points.push({
            x: currentOffsetDay,
            y: sum
          })
          // Tomorrow
          this.charts[0].points.push({
            x: 'Tomorrow',
            y: 0
          })
          this.charts[1].points.push({
            x: 'Tomorrow',
            y: 0
          })
          this.charts[2].points.push({
            x: 'Tomorrow',
            y: 0
          })
          this.showCharts = true
          this.$store.dispatch('fetchingData', { isFetching: false })
        })
      })
    })
  },
  methods: {
    parseTimestampWithoutOffset (tstmp) {
      let tstmpAsArr = tstmp.split('-')
      let actualDay = +`${tstmpAsArr[2][0]}${tstmpAsArr[2][1]}`
      let year = `${tstmpAsArr[0][2]}${tstmpAsArr[0][3]}`
      let month = `${tstmpAsArr[1]}`
      let day = actualDay < 10 ? '0' + actualDay : actualDay
      return `${day}.${month}.${year}`
    },
    parseTimestamp (tstmp) {
      let tstmpAsArr = tstmp.split('-')
      let actualDay = +`${tstmpAsArr[2][0]}${tstmpAsArr[2][1]}` + 1
      let year = `${tstmpAsArr[0][2]}${tstmpAsArr[0][3]}`
      let month = `${tstmpAsArr[1]}`
      let day = actualDay < 10 ? '0' + actualDay : actualDay
      return `${day}.${month}.${year}`
    },
    onMarkerClick (e) {
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
    getDate (offset) {
      const d = new Date()
      let newDate = new Date(d.setDate(d.getDate() - offset))
      let fullYear = newDate.getFullYear().toString()
      let lastDigitsInYear = '' + fullYear[2] + '' + fullYear[3]
      return `${newDate.getDate()}.${newDate.getMonth() + 1}.${lastDigitsInYear}`
    },
    getDateForParams (offset) {
      const d = new Date()
      let newDate = new Date(d.setDate(d.getDate() - offset))
      let month = newDate.getMonth() + 1 < 10 ? '0' + (newDate.getMonth() + 1) : newDate.getMonth() + 1
      let day = newDate.getDate() < 10 ? '0' + newDate.getDate() : newDate.getDate()
      return `${newDate.getFullYear()}-${month}-${day}`
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
    }
  }
}
</script>

<style lang="scss">
  .logo {
    display: block;
    max-width: 100%;
    height: auto;
    margin: 50px auto 40px;
  }
  h4 {
    @include fnt(300, normal);
    font-size: 12px;
    line-height: 12px;
    color: $primary;
    margin: 0;
    padding: 0;
    user-select: none;
  }
  .charts-container {
    background-repeat: no-repeat;
    background-position: 100% 0;
    background-size: 100% auto;
    background-image: url('../assets/charts-bg.svg');
  }
  .charts {
    width: 100vw;
    height: 120px;
    margin: 40px 0;
  }
  .date {
    text-align: center;
    margin-bottom: 32px;
    user-select: none;
    span {
      @include fnt(normal, normal);
      font-size: 16px;
      line-height: 16px;
      color: $primary;
    }
  }
  .today-total-inf {
    display: flex;
    width: 263px;
    margin: 53px auto 0;
    justify-content: center;
    align-items: center;
    div {
      h2 {
        margin: 0;
        padding: 0;
        @include fnt(300, normal);
        font-size: 30px;
        line-height: 30px;
        color: $primary;
      }
      h4 {
        margin: 0;
        padding: 0;
        @include fnt(normal, normal);
        font-size: 12px;
        line-height: 12px;
        color: $primary;
      }
      .divider-3 {
        display: block;
        width: 17px;
        height: 1px;
        margin: 11px 0;
        background-repeat: no-repeat;
        background-position: 0 0;
        background-size: 100% 100%;
        background-image: url('../assets/divider-3.svg');
      }
      .divider-4 {
        display: block;
        width: 17px;
        height: 1px;
        margin: 11px 0 11px auto;
        background-repeat: no-repeat;
        background-position: 0 0;
        background-size: 100% 100%;
        background-image: url('../assets/divider-4.svg');
      }
      width: 50%;
      padding: 12px 0;
      &:first-child {
        border-right: 1px solid #313B64;
      }
      &:last-child {
        text-align: right;
      }
    }
  }
</style>
