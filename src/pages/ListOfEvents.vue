<template>
  <q-page class="page page--list-of-events content" :key="'page-key-' + pageKey">
    <q-header class="header">
      <router-link to="/entry">
        {{routeTitle}}
      </router-link>
      <div class="date-filter" v-if="showCalendarFilter" @click.prevent="showCalendarFilterPopup = true">
        <span v-if="dateFromFilter && dateToFilter">
          {{dateFromFilter}} - {{dateToFilter}}
        </span>
        <a href="#" class="callendar-btn"></a>
      </div>
    </q-header>
    <div class="calendar-filter-popup" v-if="showCalendarFilterPopup">
      <div class="calendar-filter-popup__window">
        <i class="close-calendar-filer-popup" @click.prevent="showCalendarFilterPopup = false"></i>
        <h3>Оберить проміжок:</h3>
        <div>
          <label for="date-from">Від: <span>{{dateFromFilter || '___-__-__'}}</span></label>
          <label for="date-to">До: <span>{{dateToFilter || '___-__-__'}}</span></label>
        </div>
        <button @click.prevent="submitCalendarFilter">Підтвердити</button>
        <input type="date" id="date-from" v-model="dateFromFilter">
        <input type="date" id="date-to" v-model="dateToFilter">
      </div>
    </div>
    <div class="container">
      <form class="search">
        <div class="input-wrapper">
          <i class="search-icon"></i>
          <input type="text" placeholder="Введіть подію, яку ви шукаєте…" v-model="filterString">
          <a href="#" class="reset-btn" @click.prevent="resetFilterField"></a>
        </div>
        <button @click.prevent="false">Знайти</button>
      </form>
      <ul class="events-list">
        <li v-for="(event, index) in filteredEvents" :key="index">
          <router-link
            :to="`/event/${event.id}/${event.title}/${event.city}/${event.concertHall}/${event.date}/${event.time}/${event.creator}/${isGeneral}/${isToday}`"
            class="event-teaser">
            <i class="link-icon"></i>
            <div class="thumbnail-and-inf">
              <div class="thumbnail"
                   :style="{
                      'background-image': 'url(' + event.thumbnail + ')'
                     }">
              </div>
              <div class="inf">
                <h5>Організатор: <span>{{event.creator}}</span></h5>
                <h2>{{event.title}}</h2>
                <p>{{event.city}} {{event.concertHall}}</p>
                <p>{{event.date}} {{event.time}}</p>
              </div>
            </div>
            <div class="divider"></div>
            <div class="total">
              <p><span>{{event.orders}}</span> Замовлення</p>
              <p><span>{{event.tickets}}</span> Квитки</p>
              <p>Сума <span>{{event.total}}</span> грн</p>
            </div>
          </router-link>
        </li>
      </ul>
    </div>
  </q-page>
</template>

<script>
import { epEvents, epEventsArchive, serviceURL, epEventsToday } from '../api/endpoints'

export default {
  name: 'ListOfEvents',
  data () {
    return {
      filterString: '',
      events: [],
      showCalendarFilter: false,
      showCalendarFilterPopup: false,
      dateFromFilter: null,
      dateToFilter: null,
      pageKey: 0
    }
  },
  mounted () {
    this.gettingData()
  },
  computed: {
    routeTitle () {
      let title = ''
      switch (this.$route.params.listId) {
        case 'today':
          title = 'Події за сьогодні'
          break
        case 'general':
          title = 'Загальні'
          break
        case 'archive':
          title = 'Архів'
          break
      }
      return title
    },
    routeInf () {
      let inf = false
      if (this.$route.params.eventId) {
        let data = this.events.filter(item => +item.id === +this.$route.params.eventId)[0]
        inf = {
          place: data.city + ' ' + data.concertHall,
          date: data.date + ' ' + data.time,
          creator: data.creator
        }
      }
      return inf
    },
    filteredEvents () {
      let events = this.events
      if (this.filterString) {
        let filterStringToArr = this.filterString.split(' ')
        for (let fi = 0; fi < filterStringToArr.length; fi++) {
          if (filterStringToArr[fi].length > 0) {
            let r = new RegExp(filterStringToArr[fi], 'gi')
            events = []
            for (let i = 0; i < this.events.length; i++) {
              let searchStr = `${this.events[i].creator}${this.events[i].title}${this.events[i].city}${this.events[i].concertHall}${this.events[i].date}${this.events[i].time}${this.events[i].tickets}${this.events[i].orders}${this.events[i].total}`
              if (r.test(searchStr)) events.push(this.events[i])
            }
          }
        }
      }
      return events
    },
    isGeneral () {
      let g = false
      if (this.$route.params.listId === 'general') {
        g = true
      }
      return g
    },
    isToday () {
      let t = false
      if (this.$route.params.listId === 'today') {
        t = true
      }
      return t
    }
  },
  methods: {
    gettingData () {
      this.events = []
      let d = new Date()
      let day = d.getDate() < 10 ? '0' + d.getDate() : d.getDate()
      let month = d.getMonth() + 1 < 10 ? '0' + (d.getMonth() + 1) : d.getMonth() + 1
      let endPoint = epEvents
      let paramsForEndpoint = {
        dateFrom: d.getFullYear() + '-' + month + '-' + day + 'T00:00:00',
        dateTo: d.getFullYear() + '-' + month + '-' + day + 'T23:59:59'
      }
      if (this.$route.params.listId === 'archive') {
        endPoint = epEventsArchive
        this.showCalendarFilter = true
      }
      if (this.$route.params.listId === 'today') {
        endPoint = epEventsToday
      }
      if (this.$route.params.listId === 'general') {
        if (this.dateFromFilter && this.dateToFilter) {
          paramsForEndpoint = {
            dateFrom: this.dateFromFilter + 'T00:00:00',
            dateTo: this.dateToFilter + 'T23:59:59'
          }
        } else {
          paramsForEndpoint = null
        }
        this.showCalendarFilter = true
      }
      this.$store.dispatch('fetchingData', { isFetching: true })
      this.$axios({
        methods: 'get',
        url: endPoint,
        params: paramsForEndpoint,
        headers: {
          'Authorization': 'Bearer  ' + this.$store.getters.getAccessToken
        }
      }).then((res) => {
        for (let i = 0; i < res.data.length; i++) {
          let dateOfBegin = new Date(res.data[i].beginDate)
          let d = dateOfBegin.getDate() < 10 ? '0' + dateOfBegin.getDate() : dateOfBegin.getDate()
          let m = dateOfBegin.getMonth() + 1 < 10 ? '0' + dateOfBegin.getMonth() : dateOfBegin.getMonth()
          let hour = dateOfBegin.getHours() < 10 ? '0' + dateOfBegin.getHours() : dateOfBegin.getHours()
          let min = dateOfBegin.getMinutes() < 10 ? '0' + dateOfBegin.getMinutes() : dateOfBegin.getMinutes()
          this.events.push({
            id: res.data[i].id,
            creator: res.data[i].organizator.firstName + ' ' + res.data[i].organizator.lastName,
            thumbnail: serviceURL + '/image-service/image-service/file/' + res.data[i].mainImageSmall.path,
            title: res.data[i].eventName.valueUA,
            city: res.data[i].cityName.valueUA,
            concertHall: res.data[i].hallName.valueUA,
            date: `${d}.${m}.${dateOfBegin.getFullYear()}`,
            time: `${hour}:${min}`,
            orders: res.data[i].ordersCount,
            tickets: res.data[i].ticketsCount,
            total: res.data[i].moneysSum || 0
          })
        }
        this.$store.dispatch('fetchingData', { isFetching: false })
      })
    },
    resetFilterField () {
      this.filterString = ''
    },
    submitCalendarFilter () {
      this.pageKey += 1
      this.showCalendarFilterPopup = false
      this.gettingData()
    }
  }
}
</script>

<style lang="scss">
  @import '../css/quasar.variables';
  .date-filter {
    span {
      display: inline-block;
      font-size: 12px;
      line-height: 20px;
      margin-right: 5px;
      vertical-align: middle;
    }
    .callendar-btn {
      display: inline-block;
      vertical-align: middle;
      width: 20px;
      height: 20px;
      background-repeat: no-repeat;
      background-position: 50% 50%;
      background-size: contain;
      background-image: url('../assets/calendar.svg');
      &:before {
        display: none;
      }
    }
  }
  .calendar-filter-popup {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background-color: rgba(0,0,0,.7);
    color: #fff;
    &__window {
      background-image: $linear_bg_3;
      width: calc(100% - 30px);
      padding: 15px;
      border-radius: 15px;
      .close-calendar-filer-popup {
        display: block;
        width: 20px;
        height: 20px;
        background-repeat: no-repeat;
        background-position: 50% 50%;
        background-size: contain;
        background-image: url('../assets/close-popup-icon.svg');
        margin-left: auto;
      }
      h3 {
        font-size: 20px;
        line-height: 20px;
        text-align: center;
        margin: 0 0 15px;
        padding: 0;
      }
      label {
        font-size: 16px;
        span {
          display: inline-block;
          border: 1px solid #fff;
          padding: 3px;
          border-radius: 3px;
        }
      }
      input[type="date"] {
        display: block;
        width: 0;
        height: 0;
        margin: 0;
        padding: 0;
        opacity: 0;
      }
      div {
        display: flex;
        justify-content: space-between;
      }
      button {
        display: block;
        border: none;
        background-color: transparent;
        outline: none;
        @include fnt(normal, normal);
        font-size: 12px;
        color: $secondary;
        padding: 0;
        margin: 30px auto 0;
        width: 150px;
      }
    }
  }
  .search {
    display: flex;
    margin: 0 0 10px;
    padding: 0;
    .search-icon {
      display: block;
      width: 16px;
      height: 16px;
      margin-right: 11px;
      background-repeat: no-repeat;
      background-position: 50% 50%;
      background-size: contain;
      background-image: url('../assets/search-icon.svg');
    }
    .input-wrapper {
      display: flex;
      width: 100%;
      align-items: center;
      border: 1px solid #172034;
      border-radius: 8px;
      padding: 9px 11px;
      background-color: #222C45;
      input {
        display: block;
        width: 100%;
        font-size: 10px;
        line-height: 12px;
        @include fnt(300, normal);
        background-color: transparent;
        outline: none;
        border: none;
        color: $primary;
        &::-webkit-input-placeholder {
          color: #666B79;
          opacity: 1;
        }
        &::-moz-placeholder {
          color: #666B79;
          opacity: 1;
        }
        &:-ms-input-placeholder {
          color: #666B79;
          opacity: 1;
        }
        &:-moz-placeholder {
          color: #666B79;
          opacity: 1;
        }
      }
      .reset-btn {
        display: block;
        margin-left: 11px;
        width: 18px;
        height: 18px;
        background-repeat: no-repeat;
        background-position: 50% 50%;
        background-size: contain;
        background-image: url('../assets/reset-icon.svg');
      }
    }
    button {
      border: none;
      background-color: transparent;
      outline: none;
      @include fnt(normal, normal);
      font-size: 12px;
      color: $secondary;
      margin-left: 11px;
      padding: 0;
    }
  }
  .events-list {
    list-style: none;
    margin: 0;
    padding: 0;
    .event-teaser {
      position: relative;
      display: block;
      padding: 14px 14px 12px;
      margin: 0 0 10px;
      border-radius: 5px;
      background: linear-gradient(45deg, #435179 0%, #384366 70%, #323c5d 100%);
      border: 1px solid #293557;
      box-shadow: 0px 3px 6px rgba(0, 0, 0, 0.09);
      text-decoration: none;
      color: $primary;
      .link-icon {
        display: block;
        width: 24px;
        height: 24px;
        background-repeat: no-repeat;
        background-position: 50% 50%;
        background-size: contain;
        background-image: url('../assets/link-icon.svg');
        position: absolute;
        top: 22px;
        right: 16px;
      }
      .thumbnail-and-inf {
        display: flex;
        align-items: flex-start;
        .thumbnail {
          width: 34px;
          max-width: 34px;
          min-width: 34px;
          height: 34px;
          background-repeat: no-repeat;
          background-position: 50% 50%;
          background-size: cover;
        }
        .inf {
          margin-left: 10px;
          h5 {
            margin: 0;
            padding: 0;
            @include fnt(300, normal);
            font-size: 10px;
            line-height: 10px;
            span {
              font-weight: normal;
            }
          }
          h2 {
            margin: 12px 0 10px;
            padding: 0;
            @include fnt(500, normal);
            font-size: 14px;
            line-height: 16px;
            max-width: 172px;
          }
          p {
            margin: 0;
            padding: 0;
            @include fnt(300, normal);
            font-size: 10px;
            line-height: 14px;
          }
        }
      }
      .divider {
        height: 1px;
        background-color: #2B3653;
        margin: 10px 0;
      }
      .total {
        display: flex;
        justify-content: space-between;
        p {
          margin: 0;
          padding: 0;
          @include fnt(300, normal);
          font-size: 10px;
          line-height: 10px;
          span {
            font-size: 12px;
            font-weight: 900;
          }
        }
      }
    }
  }
</style>
