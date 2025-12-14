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
          <span>Організатор: <b>{{eventOrganisator}}</b></span>
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
            <linearGradient id="linear-5" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#7B8AA1"/>
              <stop offset="100%" stop-color="#9CAAD1"/>
            </linearGradient>
            <linearGradient id="linear-6" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%"   stop-color="#FFB169"/>
              <stop offset="100%" stop-color="#FF7A4D"/>
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
          <li class="online">
            <h4>Онлайн:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].online.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].online.percents}} %</span>
            </h3>
          </li>
          <li class="offline">
            <h4>Офлайн:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].offline.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].offline.percents}} %</span>
            </h3>
          </li>
          <li class="reserved">
            <h4>Заброньовано:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].reserved.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].reserved.percents}} %</span>
            </h3>
          </li>
          <li class="invitations">
            <h4>Запрошень:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].invitations.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].invitations.percents}} %</span>
            </h3>
          </li>
          <li class="cash_register">
            <h4>Службових:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].cash_register.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].cash_register.percents || 0}} %</span>
            </h3>
          </li>
          <li class="returned">
            <h4>Повернено:</h4>
            <h3>
              <span>{{detailInf[activeTabIndex].returned.val | thousant}}</span> {{activeTabIndex === 0 ? 'грн' : 'штук'}}
              <span>{{detailInf[activeTabIndex].returned.percents}} %</span>
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
                <td></td>
                <td v-for="(inf, index) in tableInf.prices" :key="index">
                  <b>{{inf !== undefined && inf !== null ? inf : '-'}}</b> грн
                </td>
              </tr>
              <tr>
                <td>Квота, шт.</td>
                <td><b>{{allTicketsData ? allTicketsData.createdTickets : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.createdTickets" :key="index">
                  <b>{{inf !== undefined && inf !== null ? inf : '-'}}</b>
                </td>
              </tr>
              <tr>
                <td>Квота на суму</td>
                <td><b>{{allTicketsData ? allTicketsData.createdTicketsSum : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.createdTicketsSum" :key="index">
                  <b>{{inf !== undefined && inf !== null ? inf : '-'}}</b>
                </td>
              </tr>
              <tr>
                <td>Доступно, шт.</td>
                <td><b>{{allTicketsData ? allTicketsData.quantity : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.quantity" :key="index">
                  <b>{{inf !== undefined && inf !== null ? inf : '-'}}</b>
                </td>
              </tr>
              <tr>
                <td>Доступно на суму</td>
                <td><b>{{allTicketsData ? allTicketsData.quantityOfSum : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.quantityOfSum" :key="index">
                  <b>{{inf !== undefined && inf !== null ? inf : '-'}}</b>
                </td>
              </tr>
              <tr>
                <td>Запрошення, шт</td>
                <td><b>{{allTicketsData ? allTicketsData.invitations : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.invitations" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Запрошення на суму</td>
                <td><b>{{allTicketsData ? allTicketsData.invitationsOfSum : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.invitationsOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Продано, шт</td>
                <td><b>{{allTicketsData ? allTicketsData.solded : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.solded" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Продано на суму</td>
                <td><b>{{allTicketsData ? allTicketsData.soldedOfSum : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.soldedOfSum" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Заброньовано, шт</td>
                <td><b>{{allTicketsData ? allTicketsData.reserved : '-'}}</b></td>
                <td v-for="(inf, index) in tableInf.reserved" :key="index">
                  <b>{{inf}}</b>
                </td>
              </tr>
              <tr>
                <td>Заброньовано на суму</td>
                <td><b>{{allTicketsData ? allTicketsData.reservedOfSum : '-'}}</b></td>
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
                <td>Квота, шт.:</td>
                <td><b>{{allTicketsData ? allTicketsData.createdTickets : '-'}}</b></td>
                <td>На суму:</td>
                <td><b>{{allTicketsData ? allTicketsData.createdTicketsSum : '-'}}</b></td>
              </tr>
              <tr>
                <td>Доступно, шт.:</td>
                <td><b>{{allTicketsData ? allTicketsData.availableTickets : '-'}}</b></td>
                <td>На суму:</td>
                <td><b>{{allTicketsData ? allTicketsData.availableTicketsSum : '-'}}</b></td>
              </tr>
              <tr>
                <td>Запрошення, шт:</td>
                <td><b>{{allTicketsData ? allTicketsData.invitations : '-'}}</b></td>
                <td>На суму:</td>
                <td><b>{{allTicketsData ? allTicketsData.invitationsOfSum : '-'}}</b></td>
              </tr>
              <tr>
                <td>Продано, шт:</td>
                <td><b>{{allTicketsData ? allTicketsData.solded : '-'}}</b></td>
                <td>На суму:</td>
                <td><b>{{allTicketsData ? allTicketsData.soldedOfSum : '-'}}</b></td>
              </tr>
              <tr>
                <td>Заброньовано, шт:</td>
                <td><b>{{allTicketsData ? allTicketsData.reserved : '-'}}</b></td>
                <td>На суму:</td>
                <td><b>{{allTicketsData ? allTicketsData.reservedOfSum : '-'}}</b></td>
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
import { epEventInCount, epEventInSum, epEvents, epEventSoldShortInfo, epEventDetailsTableForDate } from '../api/endpoints'

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
          online: { id: 'online', val: 0, percents: 0 },
          offline: { id: 'offline', val: 0, percents: 0 },
          reserved: { id: 'reserved', val: 0, percents: 0 },
          invitations: { id: 'invitations', val: 0, percents: 0 },
          cash_register: { id: 'cash_register', val: 0, percents: 0 },
          returned: { id: 'returned', val: 0, percents: 0 }
        },
        {
          online: { id: 'online', val: 0, percents: 0 },
          offline: { id: 'offline', val: 0, percents: 0 },
          reserved: { id: 'reserved', val: 0, percents: 0 },
          invitations: { id: 'invitations', val: 0, percents: 0 },
          cash_register: { id: 'cash_register', val: 0, percents: 0 },
          returned: { id: 'returned', val: 0, percents: 0 }
        }
      ],
      tableInf: {
        colors: [],
        prices: [],
        quantity: [],
        quantityOfSum: [],
        createdTickets: [],
        createdTicketsSum: [],
        invitations: [],
        invitationsOfSum: [],
        solded: [],
        soldedOfSum: [],
        reserved: [],
        reservedOfSum: []
      },
      allTicketsData: null,
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
    const percentOf = (value, total) => {
      return total > 0 ? ((+value * 100 / +total).toFixed(2)) : 0
    }
    this.$axios({
      methods: 'get',
      url: epEventInSum + '/' + this.idOfEvent,
      params: params,
      headers: {
        'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
      }
    }).then((res) => {
      const offlineTicketSum = +res.data.offlineTicketSum || 0
      const onlineTicketSum = +res.data.onlineTicketSum || 0
      const bookedTicketSum = +res.data.bookedTicketSum || 0
      const inviteTicketSum = +res.data.inviteTicketSum || 0
      const hardLockedTicketSum = +res.data.hardLockedTicketSum || 0
      const returnedTicketSum = +res.data.returnedTicketSum || 0
      const totalSegmentsSum = offlineTicketSum + onlineTicketSum + bookedTicketSum + inviteTicketSum + hardLockedTicketSum + returnedTicketSum

      // Всього продано (офлайн + онлайн) — те що на колі
      this.currentCurrency = onlineTicketSum + offlineTicketSum
      this.totalCurrency = this.currentCurrency
      this.totalCurrencyPercents = percentOf(this.currentCurrency, this.totalCurrency)

      this.detailInf[0].offline.val = offlineTicketSum
      this.detailInf[0].offline.percents = percentOf(offlineTicketSum, totalSegmentsSum)
      this.detailInf[0].online.val = onlineTicketSum
      this.detailInf[0].online.percents = percentOf(onlineTicketSum, totalSegmentsSum)
      this.detailInf[0].invitations.val = inviteTicketSum
      this.detailInf[0].invitations.percents = percentOf(inviteTicketSum, totalSegmentsSum)
      this.detailInf[0].reserved.val = bookedTicketSum
      this.detailInf[0].reserved.percents = percentOf(bookedTicketSum, totalSegmentsSum)
      this.detailInf[0].cash_register.val = hardLockedTicketSum
      this.detailInf[0].cash_register.percents = percentOf(hardLockedTicketSum, totalSegmentsSum)
      this.detailInf[0].returned.val = returnedTicketSum
      this.detailInf[0].returned.percents = percentOf(returnedTicketSum, totalSegmentsSum)
      this.$axios({
        methods: 'get',
        url: epEventInCount + '/' + this.idOfEvent,
        params: params,
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((res) => {
        const offlineTicketCount = +res.data.offlineTicketCount || 0
        const onlineTicketCount = +res.data.onlineTicketCount || 0
        const bookedTicketCount = +res.data.bookedTicketCount || 0
        const inviteTicketCount = +res.data.inviteTicketCount || 0
        const hardLockedTicketCount = +res.data.hardLockedTicketCount || 0
        const returnedTicketCount = +res.data.returnedTicketCount || 0
        const totalSegmentsCount = offlineTicketCount + onlineTicketCount + bookedTicketCount + inviteTicketCount + hardLockedTicketCount + returnedTicketCount

        this.currentQuantity = onlineTicketCount + offlineTicketCount
        this.totalQuantity = this.currentQuantity
        this.totalQuantityPercents = percentOf(this.currentQuantity, this.totalQuantity)

        this.detailInf[1].offline.val = offlineTicketCount
        this.detailInf[1].offline.percents = percentOf(offlineTicketCount, totalSegmentsCount)
        this.detailInf[1].online.val = onlineTicketCount
        this.detailInf[1].online.percents = percentOf(onlineTicketCount, totalSegmentsCount)
        this.detailInf[1].invitations.val = inviteTicketCount
        this.detailInf[1].invitations.percents = percentOf(inviteTicketCount, totalSegmentsCount)
        this.detailInf[1].reserved.val = bookedTicketCount
        this.detailInf[1].reserved.percents = percentOf(bookedTicketCount, totalSegmentsCount)
        this.detailInf[1].cash_register.val = hardLockedTicketCount
        this.detailInf[1].cash_register.percents = percentOf(hardLockedTicketCount, totalSegmentsCount)
        this.detailInf[1].returned.val = returnedTicketCount
        this.detailInf[1].returned.percents = percentOf(returnedTicketCount, totalSegmentsCount)
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
    const apiUrl = epEventDetailsTableForDate + '/' + this.idOfEvent
    console.log('🔗 API URL:', apiUrl)
    console.log('📅 API Params:', params)
    console.log('🆔 Event ID:', this.idOfEvent)
    
    this.$axios({
      methods: 'get',
      url: apiUrl,
      params: params,
      headers: {
        'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
      }
    }).then((res) => {
      console.log('📊 API Response for event details table:', res.data)
      console.log('📊 API Response FULL DATA (stringified):', JSON.stringify(res.data, null, 2))
      
      // Знаходимо елемент "All_Tickets" для колонки "Всього"
      let allTicketsItem = null
      for (let i = 0; i < res.data.length; i++) {
        if (res.data[i].color === 'All_Tickets') {
          allTicketsItem = res.data[i]
          console.log('📋 All_Tickets item:', allTicketsItem)
          console.log('📋 All_Tickets FULL KEYS:', Object.keys(allTicketsItem))
          console.log('📋 All_Tickets createdTickets value:', allTicketsItem.createdTickets, 'type:', typeof allTicketsItem.createdTickets)
          console.log('📋 All_Tickets createdTicketsSum value:', allTicketsItem.createdTicketsSum, 'type:', typeof allTicketsItem.createdTicketsSum)
          break
        }
      }
      
      // Зберігаємо дані "All_Tickets" для колонки "Всього"
      if (allTicketsItem) {
        this.allTicketsData = {
          price: +allTicketsItem.price || 0,
          // КВОТА: createdTickets - загальна кількість створених квитків (квота)
          createdTickets: +allTicketsItem.createdTickets || 0,
          createdTicketsSum: +allTicketsItem.createdTicketsSum || 0,
          // ДОСТУПНО: availableTickets - квитки доступні для продажу
          availableTickets: +allTicketsItem.availableTickets || 0,
          availableTicketsSum: +allTicketsItem.availableTicketsSum || 0,
          quantity: +allTicketsItem.availableTickets || 0,
          quantityOfSum: +allTicketsItem.availableTicketsSum || 0,
          // ЗАПРОШЕННЯ
          invitations: +allTicketsItem.inviteTickets || 0,
          invitationsOfSum: +allTicketsItem.inviteTicketsSum || 0,
          // ПРОДАНО
          solded: +allTicketsItem.soldTickets || 0,
          soldedOfSum: +allTicketsItem.soldTicketsSum || 0,
          // ЗАБРОНЬОВАНО
          reserved: +allTicketsItem.bookedTickets || 0,
          reservedOfSum: +allTicketsItem.bookedTicketsSum || 0
        }
      } else {
        // Якщо "All_Tickets" немає, підсумовуємо всі дані з масиву (fallback)
        let totalCreatedTickets = 0      // КВОТА
        let totalCreatedTicketsSum = 0
        let totalAvailableTickets = 0    // ДОСТУПНО
        let totalAvailableTicketsSum = 0
        let totalInviteTickets = 0
        let totalInviteTicketsSum = 0
        let totalSoldTickets = 0
        let totalSoldTicketsSum = 0
        let totalBookedTickets = 0
        let totalBookedTicketsSum = 0

        for (let i = 0; i < res.data.length; i++) {
          const item = res.data[i]
          if (item.color !== 'All_Tickets') {
            totalCreatedTickets += (+item.createdTickets || 0)      // КВОТА
            totalCreatedTicketsSum += (+item.createdTicketsSum || 0)
            totalAvailableTickets += (+item.availableTickets || 0)  // ДОСТУПНО
            totalAvailableTicketsSum += (+item.availableTicketsSum || 0)
            totalInviteTickets += (+item.inviteTickets || 0)
            totalInviteTicketsSum += (+item.inviteTicketsSum || 0)
            totalSoldTickets += (+item.soldTickets || 0)
            totalSoldTicketsSum += (+item.soldTicketsSum || 0)
            totalBookedTickets += (+item.bookedTickets || 0)
            totalBookedTicketsSum += (+item.bookedTicketsSum || 0)
          }
        }

        this.allTicketsData = {
          price: 0,
          // КВОТА: загальна кількість створених квитків
          createdTickets: totalCreatedTickets,
          createdTicketsSum: totalCreatedTicketsSum,
          // ДОСТУПНО: квитки доступні для продажу
          availableTickets: totalAvailableTickets,
          availableTicketsSum: totalAvailableTicketsSum,
          quantity: totalAvailableTickets,
          quantityOfSum: totalAvailableTicketsSum,
          invitations: totalInviteTickets,
          invitationsOfSum: totalInviteTicketsSum,
          solded: totalSoldTickets,
          soldedOfSum: totalSoldTicketsSum,
          reserved: totalBookedTickets,
          reservedOfSum: totalBookedTicketsSum
        }
      }

      // Очищаємо всі масиви
      this.tableInf.colors = []
      this.tableInf.quantityOfSum = []
      this.tableInf.prices = []
      this.tableInf.quantity = []
      this.tableInf.createdTickets = []
      this.tableInf.createdTicketsSum = []
      this.tableInf.invitations = []
      this.tableInf.invitationsOfSum = []
      this.tableInf.reserved = []
      this.tableInf.reservedOfSum = []
      this.tableInf.soldedOfSum = []
      this.tableInf.solded = []

      // Заповнюємо дані з epEventDetailsTableForDate (виключаємо "All_Tickets")
      for (let i = 0; i < res.data.length; i++) {
        const item = res.data[i]
        const color = item.color
        
        // Пропускаємо "All_Tickets" - він використовується тільки для колонки "Всього"
        if (color === 'All_Tickets') {
          continue
        }
        
        console.log(`🎨 Processing color ${color}:`)
        console.log(`   📦 Full item keys:`, Object.keys(item))
        console.log(`   ⭐ createdTickets:`, item.createdTickets, `(type: ${typeof item.createdTickets})`)
        console.log(`   ⭐ createdTicketsSum:`, item.createdTicketsSum, `(type: ${typeof item.createdTicketsSum})`)
        console.log(`   ✅ availableTickets:`, item.availableTickets, `(type: ${typeof item.availableTickets})`)
        console.log(`   ✅ availableTicketsSum:`, item.availableTicketsSum, `(type: ${typeof item.availableTicketsSum})`)
        console.log(`   📋 Full item:`, JSON.stringify(item, null, 2))
        
        this.tableInf.colors.push(color)
        this.tableInf.prices.push(+item.price || 0)
        
        // ⭐ КВОТА: createdTickets - загальна кількість створених квитків (квота)
        // Джерело: epEventDetailsTableForDate поле createdTickets
        const createdTickets = +item.createdTickets || 0
        const createdTicketsSum = +item.createdTicketsSum || 0
        this.tableInf.createdTickets.push(createdTickets)
        this.tableInf.createdTicketsSum.push(createdTicketsSum)
        
        // ⭐ ДОСТУПНО: availableTickets - квитки доступні для продажу
        // Джерело: epEventDetailsTableForDate поле availableTickets
        this.tableInf.quantity.push(+item.availableTickets || 0)
        this.tableInf.quantityOfSum.push(+item.availableTicketsSum || 0)
        
        // Інші дані: запрошення, заброньовані, продані
        this.tableInf.invitations.push(+item.inviteTickets || 0)
        this.tableInf.invitationsOfSum.push(+item.inviteTicketsSum || 0)
        this.tableInf.reserved.push(+item.bookedTickets || 0)
        this.tableInf.reservedOfSum.push(+item.bookedTicketsSum || 0)
        this.tableInf.solded.push(+item.soldTickets || 0)
        this.tableInf.soldedOfSum.push(+item.soldTicketsSum || 0)
      }
      
      console.log('✅ Final QUOTA (createdTickets):', this.tableInf.createdTickets)
      console.log('✅ Final QUOTA SUM (createdTicketsSum):', this.tableInf.createdTicketsSum)
      console.log('✅ Final AVAILABLE (quantity):', this.tableInf.quantity)
      console.log('✅ Final AVAILABLE SUM (quantityOfSum):', this.tableInf.quantityOfSum)
      console.log('✅ Final allTicketsData:', this.allTicketsData)
    }).catch((err) => {
      console.error('❌ ERROR loading event details table:', err)
      console.error('❌ ERROR details:', {
        status: err.response?.status,
        data: err.response?.data,
        url: err.config?.url,
        params: err.config?.params
      })
      this.$store.dispatch('fetchingData', { isFetching: false })
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
        const value = array[i]
        if (value !== undefined && value !== null && !isNaN(value)) {
          total += +value
        }
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
        &.returned {
          stroke: url(#linear-6);
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
    width: 100%;
    max-width: 420px;
    margin: 30px auto 0;
    ul {
      list-style: none;
      margin: 0;
      padding: 0;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 16px 20px;
    }
    li {
      display: block;
      color: $primary;
      text-align: center;
      h4 {
        @include fnt(300, normal);
        font-size: 12px;
        line-height: 12px;
        margin: 0 0 4px;
        padding: 0;
        text-align: center;
      }
      h3 {
        @include fnt(500, normal);
        font-size: 11px;
        line-height: 14px;
        margin: 0;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        span {
          font-size: 14px;
        }
        &:before {
          content: '';
          display: inline-block;
          width: 10px;
          height: 9px;
          border: 1px solid $primary;
          border-radius: 3px;
          flex-shrink: 0;
        }
      }
      &.cash_register h3:before {
        border-color: #FC93B1;
        box-shadow: 0 3px 10px rgba(#FC93B1, .7);
      }
      &.invitations h3:before {
        border-color: #26BCFF;
        box-shadow: 0 3px 10px rgba(#0357F7, .7);
      }
      &.reserved h3:before {
        border-color: #814AFF;
        box-shadow: 0 3px 10px rgba(#0357F7, .7);
      }
      &.online h3:before {
        border-color: #66E8CD;
        box-shadow: 0 3px 10px rgba(#66E8CD, .7);
      }
      &.offline h3:before {
        border-color: #FFFFFF;
        box-shadow: 0 3px 6px rgba(#FFFFFF, .7);
      }
      &.returned h3:before {
        border-color: #FF9D52;
        box-shadow: 0 3px 10px rgba(#FF9D52, .6);
      }
    }
    &--general {
      max-width: 520px;
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
          max-height: 1000px;
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
