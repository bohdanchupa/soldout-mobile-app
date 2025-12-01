<template>
  <q-page class="page page--event-detail content">
    <q-header class="header">
      <a href="#" @click.prevent="goBack">
        <div>
          <span>{{eventCity}} {{eventConcertHall}}</span>
        </div>
        {{eventTitle}}
        <div class="flex mt-1">
          <span>{{eventDate}}. {{eventTime}}</span>
          <span>Організатор:: <b>{{eventOrganisator}}</b></span>
        </div>
      </a>
    </q-header>
    <div class="container" v-if="showChart">
      <div class="tabs-container">
        <div class="tab" :class="{'active': activeTabIndex === 0}" @click.prevent="changeActiveTab(0)">
          <h4>На суму:</h4>
          <div class="tab-btn">
            <div>
              <h2>{{currentCurrency | thousant}} грн</h2>
              <h5>з {{totalCurrency | thousant}} грн | {{totalCurrencyPercents}}% </h5>
            </div>
          </div>
        </div>
        <div class="tab text-right" :class="{'active': activeTabIndex === 1}" @click.prevent="changeActiveTab(1)">
          <h4>Квитків:</h4>
          <div class="tab-btn">
            <div>
              <h2>{{currentQuantity | thousant}} штук</h2>
              <h5>з {{totalQuantity}} квитків | {{totalQuantityPercents}}% </h5>
            </div>
          </div>
        </div>
      </div>
      <h1 class="text-center">Продано на суму:</h1>
      <div class="circle-chart">
        <h2 v-if="activeTabIndex === 0"><span>{{currentCurrency | thousant}}</span> грн</h2>
        <h2 v-if="activeTabIndex === 1"><span>{{currentQuantity | thousant}}</span> штук</h2>
        <svg width="164" height="164" viewBox="0 0 164 164">
          <defs>
            <linearGradient id="linear-1" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#FF608E"/>
              <stop offset="100%" stop-color="#E59F93"/>
            </linearGradient>
            <linearGradient id="linear-2" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#9D29E6"/>
              <stop offset="100%" stop-color="#6E2FFF"/>
            </linearGradient>
            <linearGradient id="linear-3" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#3365EB"/>
              <stop offset="100%" stop-color="#26BCFF"/>
            </linearGradient>
            <linearGradient id="linear-4" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#1CFFD0"/>
              <stop offset="100%" stop-color="#1DEEFF"/>
            </linearGradient>
          </defs>
          <circle v-for="(circ, index) in detailInf[activeTabIndex]" :key="index"
                  v-show="circ.percents > 0"
                  cx="82" cy="82" r="80" fill="none" stroke-width="2" stroke-linecap="round"
                  :class="[circ.id]"
                  :stroke-dasharray="cLength"
                  :stroke-dashoffset="cOffset(circ.percents)"
                  :style="{
                    'transform': 'rotate(' + rotateInAngle(circ.percents) + 'deg)'
                  }"/>
        </svg>
      </div>
      <div class="chart-legend" :class="{ 'chart-legend--general': isGeneral }">
        <ul>
          <li class="cash_register">
            <h4>Каса:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].cash_register.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].cash_register.percents || 0}} %</span>
            </h3>
          </li>
          <li class="invitations">
            <h4>Запрошень:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].invitations.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].invitations.percents}} %</span>
            </h3>
          </li>
          <li class="reserved">
            <h4>Заброньовано:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].reserved.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].reserved.percents}} %</span>
            </h3>
          </li>
        </ul>
        <ul>
          <li class="online">
            <h4>Онлайн:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].online.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].online.percents}} %</span>
            </h3>
          </li>
          <li class="not_sold">
            <h4>Офлайн:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].offline.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].offline.percents}} %</span>
            </h3>
          </li>
        </ul>
      </div>
      <div v-if="isGeneral" class="sine-chart-container">
        <h1 class="text-center">Детально по днях:</h1>
        <general-sine-chart :points="points" @marker-click="markerClick($event)" />
        <div class="detail-window">
          <total-soulds v-if="showDetails && details" :details="details" :showDetail="true" :style="{'z-index': 0}"></total-soulds>
        </div>
      </div>
      <div>
        <div class="panel">
          <div class="panel__title" ref="detail-panel" @click.prevent="togglePannel('detail-panel')">
            <h2>Додаткова інформація</h2>
            <i class="panel-btn"></i>
          </div>
          <div class="panel__content">
            <table>
              <tr>
                <td>Тип квитка:</td>
                <td>Всього:</td>
                <td v-for="(color, index) in tableInf.colors" :key="index"><span :style="{'border-color': color}"></span></td>
              </tr>
              <tr>
                <td>Ціна квитка:</td>
                <td><b>{{totalOf(tableInf.prices)}}</b> грн</td>
                <td v-for="(inf, index) in tableInf.prices" :key="index">
                  <b>{{inf}}</b> грн
                </td>
              </tr>
              <tr>
                <td>Квота, шт.</td>
                <td><b>{{totalOf(tableInf.quantity)}}</b></td>
                <td v-for="(inf, index) in tableInf.quantity" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Квота на суму</td>
                <td><b>{{totalOf(tableInf.quantityOfSum)}}</b></td>
                <td v-for="(inf, index) in tableInf.quantityOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Запрошення, шт</td>
                <td><b>{{totalOf(tableInf.invitations)}}</b></td>
                <td v-for="(inf, index) in tableInf.invitations" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Запрошення на суму</td>
                <td><b>{{totalOf(tableInf.invitationsOfSum)}}</b></td>
                <td v-for="(inf, index) in tableInf.invitationsOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Продано, шт</td>
                <td><b>{{totalOf(tableInf.solded)}}</b></td>
                <td v-for="(inf, index) in tableInf.solded" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Продано на суму</td>
                <td><b>{{totalOf(tableInf.soldedOfSum)}}</b></td>
                <td v-for="(inf, index) in tableInf.soldedOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Заброньовано, шт</td>
                <td><b>{{totalOf(tableInf.reserved)}}</b></td>
                <td v-for="(inf, index) in tableInf.reserved" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Заброньовано на суму</td>
                <td><b>{{totalOf(tableInf.reservedOfSum)}}</b></td>
                <td v-for="(inf, index) in tableInf.reservedOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
            </table>
          </div>
        </div>
        <div class="panel" v-if="isGeneral">
          <div class="panel__title" ref="general-panel" @click.prevent="togglePannel('general-panel')">
            <h2>Загальна інформація</h2>
            <i class="panel-btn"></i>
          </div>
          <div class="panel__content">
            <table>
              <tr>
                <td>Всього квитків:</td>
                <td><b>{{totalOf(tableInf.quantity)}}</b></td>
                <td>На суму:</td>
                <td><b>{{totalOf(tableInf.quantityOfSum)}}</b></td>
              </tr>
              <tr>
                <td>Доступно квитків:</td>
                <td><b>{{totalOf(tableInf.quantity) - totalOf(tableInf.solded)}}</b></td>
                <td>На суму:</td>
                <td><b>{{totalOf(tableInf.quantityOfSum) - totalOf(tableInf.soldedOfSum)}}</b></td>
              </tr>
              <tr>
                <td>Заброньовано:</td>
                <td><b>{{totalOf(tableInf.reserved)}}</b></td>
                <td>На суму:</td>
                <td><b>{{totalOf(tableInf.reservedOfSum)}}</b></td>
              </tr>
              <tr>
                <td>Продано:</td>
                <td><b>{{totalOf(tableInf.solded)}}</b></td>
                <td>На суму:</td>
                <td><b>{{totalOf(tableInf.soldedOfSum)}}</b></td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script>
// eslint-disable-next-line no-unused-vars
import { epEventDetailsTable, epEventInCount, epEventInSum, epEvents, epEventSoldShortInfo, epEventDetailsTableForDate } from '../api/endpoints'

let lastAngleInPercents = 0
export default {
  name: 'EventDetails',
  components: {
    'general-sine-chart': () => import('../components/GeneralSineChart'),
    'total-soulds': () => import('../components/TotalSoulds')
  },
  data () {
    return {
      points: [],
      eventTitle: '',
      eventCity: '',
      eventConcertHall: '',
      eventDate: '',
      eventTime: '',
      eventOrganisator: '',
      strokeDashArray: 2 * Math.PI * 80,
      tableKey: 'table-before-update',
      currentCurrency: 0,
      currentQuantity: 0,
      totalCurrency: 0,
      totalQuantity: 0,
      totalCurrencyPercents: 0,
      totalQuantityPercents: 0,
      activeTabIndex: 0,
      cLength: 2 * 80 * Math.PI,
      showChart: false,
      detailInf: [
        {
          cash_register: {
            id: 'cash_register',
            val: 0,
            percents: 0
          },
          invitations: {
            id: 'invitations',
            val: 0,
            percents: 0
          },
          reserved: {
            id: 'reserved',
            val: 0,
            percents: 0
          },
          online: {
            id: 'online',
            val: 0,
            percents: 0
          },
          offline: {
            id: 'offline',
            val: 0,
            percents: 0
          }
        },
        {
          cash_register: {
            id: 'cash_register',
            val: 0,
            percents: 0
          },
          invitations: {
            id: 'invitations',
            val: 0,
            percents: 0
          },
          reserved: {
            id: 'reserved',
            val: 0,
            percents: 0
          },
          online: {
            id: 'online',
            val: 0,
            percents: 0
          },
          offline: {
            id: 'offline',
            val: 0,
            percents: 0
          }
        }
      ],
      tableInf: {
        colors: [],
        prices: [],
        quantity: [],
        quantityOfSum: [],
        invitations: [],
        invitationsOfSum: [],
        solded: [],
        soldedOfSum: [],
        reserved: [],
        reservedOfSum: []
      },
      details: null,
      idOfEvent: undefined
    }
  },
  beforeUpdate () {
    lastAngleInPercents = 0
  },
  mounted () {
    this.$store.dispatch('fetchingData', { isFetching: true })
    this.eventTitle = this.$route.params.title
    this.eventCity = this.$route.params.city
    this.eventConcertHall = this.$route.params.concertHall
    this.eventDate = this.$route.params.date
    this.eventTime = this.$route.params.time
    this.eventOrganisator = this.$route.params.organisator
    this.idOfEvent = this.$route.params.eventId
    let params = null
    let d = new Date()
    let day = d.getDate() < 10 ? '0' + d.getDate() : d.getDate()
    let month = d.getMonth() + 1 < 10 ? '0' + (d.getMonth() + 1) : d.getMonth() + 1
    if (this.$route.params.isToday === 'true') {
      params = {
        dateFrom: d.getFullYear() + '-' + month + '-' + day + 'T00:00:00',
        dateTo: d.getFullYear() + '-' + month + '-' + day + 'T23:59:59'
      }
    }
    this.$axios({
      methods: 'get',
      url: epEventInSum + '/' + this.idOfEvent,
      params: params,
      headers: {
        'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
      }
    }).then((res) => {
      this.currentCurrency = res.data.allTicketSum
      this.totalCurrency = res.data.allTicketSum + res.data.notSoldTicketSum
      this.totalCurrencyPercents = (+this.currentCurrency * 100 / +this.totalCurrency).toFixed(2)
      this.detailInf[0].offline.val = res.data.offlineTicketSum
      this.detailInf[0].offline.percents = isNaN((+res.data.offlineTicketSum * 100 / +this.currentCurrency).toFixed(2)) ? 0 : (+res.data.offlineTicketSum * 100 / +this.currentCurrency).toFixed(2)
      this.detailInf[0].online.val = res.data.onlineTicketSum
      this.detailInf[0].online.percents = isNaN((+res.data.onlineTicketSum * 100 / +this.currentCurrency).toFixed(2)) ? 0 : (+res.data.onlineTicketSum * 100 / +this.currentCurrency).toFixed(2)
      this.detailInf[0].invitations.val = res.data.inviteTicketSum
      this.detailInf[0].invitations.percents = isNaN((+res.data.inviteTicketSum * 100 / +this.currentCurrency).toFixed(2)) ? 0 : (+res.data.inviteTicketSum * 100 / +this.currentCurrency).toFixed(2)
      this.detailInf[0].reserved.val = res.data.bookedTicketSum
      this.detailInf[0].reserved.percents = isNaN((+res.data.bookedTicketSum * 100 / +this.currentCurrency).toFixed(2)) ? 0 : (+res.data.bookedTicketSum * 100 / +this.currentCurrency).toFixed(2)
      this.detailInf[0].cash_register.val = res.data.hardLockedTicketSum
      this.detailInf[0].cash_register.percents = isNaN((+res.data.hardLockedTicketSum * 100 / +this.currentCurrency).toFixed(2)) ? 0 : (+res.data.hardLockedTicketSum * 100 / +this.currentCurrency).toFixed(2)
      this.$axios({
        methods: 'get',
        url: epEventInCount + '/' + this.idOfEvent,
        params: params,
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((res) => {
        if (this.$route.params.isToday === 'true') {
          this.currentQuantity = res.data.allBoughtTicketCount
        } else {
          this.currentQuantity = res.data.allTicketCount - res.data.notSoldTicketCount
        }
        this.totalQuantity = res.data.allTicketCount
        this.totalQuantityPercents = (this.currentQuantity * 100 / this.totalQuantity).toFixed(2)
        this.detailInf[1].offline.val = res.data.offlineTicketCount
        this.detailInf[1].offline.percents = (res.data.offlineTicketCount * 100 / this.currentQuantity).toFixed(2)
        this.detailInf[1].online.val = res.data.onlineTicketCount
        this.detailInf[1].online.percents = (res.data.onlineTicketCount * 100 / this.currentQuantity).toFixed(2)
        this.detailInf[1].invitations.val = res.data.inviteTicketCount
        this.detailInf[1].invitations.percents = (res.data.inviteTicketCount * 100 / this.currentQuantity).toFixed(2)
        this.detailInf[1].reserved.val = res.data.bookedTicketCount
        this.detailInf[1].reserved.percents = (res.data.bookedTicketCount * 100 / this.currentQuantity).toFixed(2)
        this.detailInf[1].cash_register.val = res.data.hardLockedTicketCount
        this.detailInf[1].cash_register.percents = (res.data.hardLockedTicketCount * 100 / this.currentQuantity).toFixed(2)
        if (this.isGeneral) {
          this.$axios({
            methods: 'get',
            url: epEventSoldShortInfo + '/' + this.idOfEvent,
            headers: {
              'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
            }
          }).then((res) => {
            this.points = []
            for (let i = 0; i < res.data.length; i++) {
              let currentOffsetDay = this.getDate(res.data.length - i)
              this.points.push({
                x: currentOffsetDay,
                y: res.data[i].soldTicketsMoney
              })
            }
            params = {
              dateFrom: d.getFullYear() + '-' + month + '-' + day + 'T00:00:00',
              dateTo: d.getFullYear() + '-' + month + '-' + day + 'T23:59:59'
            }
            this.$axios({
              methods: 'get',
              url: epEventInSum + '/' + this.idOfEvent,
              params: {
                dateFrom: params.dateFrom,
                dateTo: params.dateTo,
                eventId: this.eventId
              },
              headers: {
                'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
              }
            }).then((res) => {
              let currentOffsetDay = this.getDate(0)
              this.points.push({
                x: currentOffsetDay,
                y: res.data.allTicketSum
              })
              this.$store.dispatch('fetchingData', { isFetching: false })
              this.showChart = true
            })
          })
        } else {
          this.$store.dispatch('fetchingData', { isFetching: false })
          this.showChart = true
        }
      })
    })
    this.$axios({
      methods: 'get',
      url: epEventDetailsTableForDate + '/' + this.idOfEvent,
      params: params,
      headers: {
        'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
      }
    }).then((res) => {
      this.tableInf.colors = []
      this.tableInf.quantityOfSum = []
      this.tableInf.prices = []
      this.tableInf.quantity = []
      this.tableInf.invitations = []
      this.tableInf.invitationsOfSum = []
      this.tableInf.reserved = []
      this.tableInf.reservedOfSum = []
      this.tableInf.soldedOfSum = []
      this.tableInf.solded = []
      for (let i = 0; i < res.data.length; i++) {
        this.tableInf.colors.push(res.data[i].color)
        this.tableInf.invitations.push(+res.data[i].inviteTickets)
        this.tableInf.invitationsOfSum.push(+res.data[i].inviteTickets * +res.data[i].price)
        this.tableInf.reserved.push(+res.data[i].bookedTickets)
        this.tableInf.reservedOfSum.push(+res.data[i].bookedTickets * +res.data[i].price)
        this.tableInf.solded.push(+res.data[i].soldTickets)
        this.tableInf.soldedOfSum.push(+res.data[i].soldTickets * +res.data[i].price)
      }
      this.$axios({
        methods: 'get',
        url: epEventDetailsTable + '/' + this.idOfEvent,
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((res) => {
        for (let i = 0; i < res.data.length; i++) {
          this.tableInf.quantityOfSum.push(+res.data[i].availableTickets * +res.data[i].price)
          this.tableInf.prices.push(+res.data[i].price)
          this.tableInf.quantity.push(+res.data[i].availableTickets)
        }
      })
    })
  },
  computed: {
    isGeneral () {
      let g = false
      if (this.$route.params.isGeneral === 'true') g = true
      return g
    },
    showDetails () {
      return this.$store.getters.isDetailsShow
    }
  },
  methods: {
    markerClick (e) {
      let d = e.split('.')[0]
      let m = e.split('.')[1]
      let y = '20' + e.split('.')[2]
      this.$axios({
        methods: 'get',
        url: epEventInSum + '/' + this.idOfEvent,
        params: {
          dateFrom: y + '-' + m + '-' + d + 'T00:00:00',
          dateTo: y + '-' + m + '-' + d + 'T23:59:59'
        },
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((res) => {
        this.details = res.data
      })
    },
    getDate (offset) {
      const d = new Date()
      let newDate = new Date(d.setDate(d.getDate() - offset))
      let fullYear = newDate.getFullYear().toString()
      let lastDigitsInYear = '' + fullYear[2] + '' + fullYear[3]
      let m = newDate.getMonth() + 1 < 10 ? '0' + (newDate.getMonth() + 1) : newDate.getMonth() + 1
      let day = newDate.getDate() < 10 ? '0' + newDate.getDate() : newDate.getDate()
      return `${day}.${m}.${lastDigitsInYear}`
    },
    totalOf (array) {
      let total = 0
      for (let i = 0; i < array.length; i++) {
        total += array[i]
      }
      return total
    },
    changeActiveTab (index) {
      lastAngleInPercents = 0
      this.activeTabIndex = index
    },
    cOffset (percent) {
      return (this.cLength + 5) - (percent * this.cLength / 100)
    },
    rotateInAngle (percent) {
      let angle = 0
      if (lastAngleInPercents > 0) {
        angle = lastAngleInPercents * 360 / 100
      }
      lastAngleInPercents += +percent
      return angle
    },
    goBack () {
      this.$router.go(-1)
    },
    togglePannel (ref) {
      if (this.$refs[ref].classList.contains('active')) {
        this.$refs[ref].classList.remove('active')
      } else {
        this.$refs[ref].classList.add('active')
      }
    }
  },
  filters: {
    thousant (value) {
      let valArr = value.toString().split('').reverse()
      for (let i = 0; i < valArr.length; i++) {
        if ((i + 1) % 3 === 0 && i < valArr.length - 1) valArr[i + 1] += ' '
      }
      return valArr.reverse().join('')
    }
  }
}
</script>

<style lang="scss">
  .detail-window {
    margin: 20px 0;
  }
  .tabs-container {
    position: relative;
    margin: 30px auto;
    width: 260px;
    display: flex;
    justify-content: space-between;
    &:after {
      content: '';
      display: block;
      position: absolute;
      bottom: 0;
      left: -20px;
      right: -20px;
      height: 45px;
      border-radius: 21px;
      background-color: rgba($primary, 0.07);
    }
    .tab {
      width: 100%;
      &:first-child {
        .tab-btn {
          &:before {
            right: 0;
            left: -20px;
          }
        }
      }
      &:last-child {
        .tab-btn {
          &:before {
            right: -20px;
            left: 0;
          }
        }
      }
      &.active {
        opacity: 1;
        h2,h4,h5 {
          opacity: 1;
        }
        .tab-btn {
          &:before {
            opacity: 1;
          }
        }
      }
      .tab-btn {
        width: 100%;
        height: 45px;
        display: flex;
        align-items: center;
        position: relative;
        z-index: 2;
        &:before {
          content: '';
          display: block;
          height: 100%;
          position: absolute;
          z-index: -1;
          top: 0;
          border: 1px solid $secondary;
          border-radius: 23px;
          background-image: linear-gradient(to left, #323c5d 0%, #414e74 40.4%, #323c5d 100%);
          opacity: 0;
          transition: opacity .3s ease-in-out;
        }
        div {
          width: 100%;
        }
      }
      h2,h4,h5 {
        margin: 0;
        padding: 0;
        @include fnt(normal, normal);
        color: $primary;
        user-select: none;
        opacity: .5;
        transition: opacity .3s ease-in-out;
      }
      h5 {
        font-weight: 300;
        font-size: 8px;
        line-height: 8px;
      }
      h4 {
        font-size: 10px;
        line-height: 10px;
        margin-bottom: 8px;
      }
      h2 {
        @include fnt(normal, normal);
        font-size: 16px;
        line-height: 16px;
        margin-bottom: 4px;
      }
    }
  }
  h1 {
    @include fnt(normal, normal);
    font-size: 18px;
    line-height: 18px;
    margin-bottom: 22px;
    color: $primary;
  }
  .circle-chart {
    width: 166px;
    height: 166px;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0 auto;
    border: 6px solid #252F4D;
    box-shadow: inset 0 10px 6px rgba(0,0,0,.18), 0 10px 6px rgba(0,0,0,.18);
    position: relative;
    svg {
      position: absolute;
      top: -5px;
      left: -5px;
      transform-origin: 50% 50%;
      transform: rotate(-135deg);
      circle {
        transform-origin: 50% 50%;
        transition: all .5s ease-in-out;
        &.cash_register {
          stroke: url(#linear-1);
        }
        &.invitations {
          stroke: url(#linear-3);
        }
        &.reserved {
          stroke: url(#linear-2);
        }
        &.online {
          stroke: url(#linear-4);
        }
        &.offline {
          stroke: $primary;
        }
      }
    }
    h2 {
      @include fnt(500, normal);
      font-size: 12px;
      line-height: 16px;
      color: $primary;
      span {
        font-size: 16px;
      }
    }
  }
  .chart-legend {
    display: flex;
    justify-content: space-between;
    margin: 30px auto 0;
    width: 300px;
    ul {
      list-style: none;
      margin: 0;
      padding: 0;
      &:last-child {
        li {
          text-align: right;
          h3 {
            &:before {
              left: 100%;
              right: auto;
              margin-right: 0;
              margin-left: 8px;
            }
          }
        }
      }
      li {
        display: block;
        color: $primary;
        margin-bottom: 20px;
        &:last-child {
          margin-bottom: 0;
        }
        h4 {
          @include fnt(300, normal);
          font-size: 12px;
          line-height: 12px;
          margin: 0 0 4px;
          padding: 0;
        }
        h3 {
          @include fnt(500, normal);
          font-size: 11px;
          line-height: 14px;
          margin: 0;
          padding: 0;
          position: relative;
          span {
            font-size: 14px;
          }
          &:before {
            content: '';
            display: block;
            width: 10px;
            height: 9px;
            border: 1px solid $primary;
            border-radius: 3px;
            position: absolute;
            right: 100%;
            bottom: 4px;
            margin-right: 8px;
          }
        }
        &.cash_register {
          h3 {
            &:before {
              border-color: #FC93B1;
              box-shadow: 0 3px 10px rgba(#FC93B1, .7);
            }
          }
        }
        &.invitations {
          h3 {
            &:before {
              border-color: #26BCFF;
              box-shadow: 0 3px 10px rgba(#0357F7, .7);
            }
          }
        }
        &.reserved {
          h3 {
            &:before {
              border-color: #814AFF;
              box-shadow: 0 3px 10px rgba(#0357F7, .7);
            }
          }
        }
        &.online {
          h3 {
            &:before {
              border-color: #66E8CD;
              box-shadow: 0 3px 10px rgba(#66E8CD, .7);
            }
          }
        }
        &.offline {
          h3 {
            &:before {
              border-color: #FFFFFF;
              box-shadow: 0 3px 6px rgba(#FFFFFF, .7);
            }
          }
        }
      }
    }
    &--general {
      display: block;
      overflow: auto;
      white-space: nowrap;
      ul {
        display: inline-block;
        white-space: nowrap;
        padding-left: 25px;
        &:last-child {
          margin-left: 10px;
          li {
            text-align: left;
            h3 {
              &:before {
                right: 100%;
                left: auto;
                margin-right: 8px;
                margin-left: 0;
              }
            }
          }
        }
        li {
          display: inline-block;
          margin-left: 35px;
          &:first-child {
            margin-left: 0;
          }
        }
      }
    }
  }
  .panel {
    width: 100%;
    background-color: #202B4A;
    position: relative;
    margin-top: 10px;
    border-top: 1px solid #192540;
    border-bottom: 1px solid #192540;
    &:first-child {
      margin-top: 30px;
    }
    &:last-child {
      margin-bottom: 50px;
    }
    &:before, &:after {
      content: '';
      display: block;
      width: 20px;
      position: absolute;
      top: -1px;
      bottom: -1px;
      background-color: #202B4A;
      border-top: 1px solid #192540;
      border-bottom: 1px solid #192540;
    }
    &:before {
      right: 100%;
    }
    &:after {
      left: 100%;
    }
    &__title {
      width: 100%;
      height: 56px;
      display: flex;
      align-items: center;
      position: relative;
      text-decoration: none;
      .panel-btn {
        display: block;
        width: 24px;
        height: 24px;
        background-repeat: no-repeat;
        background-position: 50% 50%;
        background-size: contain;
        background-image: url('../assets/panel-btn.svg');
        position: absolute;
        right: 0;
        top: 50%;
        transform-origin: 50% 50%;
        transform: translate(0, -50%);
        transition: all .3s ease-in-out;
      }
      h2 {
        @include fnt(normal, normal);
        font-size: 18px;
        line-height: 18px;
        color: $primary;
        user-select: none;
      }
      &.active {
        .panel-btn {
          transform: translate(0, -50%) rotate(180deg);
        }
        & + .panel__content {
          max-height: 240px;
        }
      }
    }
    &__content {
      overflow: auto;
      height: auto;
      max-height: 0;
      transition: max-height .3s ease-in-out;
      table {
        min-width: 100%;
      }
      tr {
        td {
          border-bottom: 1px solid #192540;
        }
        &:last-child {
          td {
            border-bottom: none;
          }
        }
      }
      td {
        @include fnt(300, normal);
        font-size: 12px;
        line-height: 12px;
        color: $primary;
        text-align: right;
        white-space: nowrap;
        padding: 4px 11px;
        b {
          font-weight: 500;
        }
        &:first-child {
          text-align: left;
          padding-left: 0;
        }
        span {
          display: block;
          width: 14px;
          border: 1px solid $primary;
          border-radius: 2px;
          margin-left: auto;
          &.cash_register {
            border-color: #FC93B1;
          }
          &.invitations {
            border-color: #26BCFF;
          }
          &.reserved {
            border-color: #814AFF;
          }
          &.online {
            border-color: #66E8CD;
          }
          &.not_sold {
            border-color: #FFFFFF;
          }
        }
      }
    }
  }
  .sine-chart-container {
    position: relative;
  }
</style>
