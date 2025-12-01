<template>
  <div class="total-soulds"
       :class="{
        'popup-detail': showPopupDetail,
        'general-detail': showGeneralDetail
       }">
    <a href="#" v-if="showPopupDetail" class="close-popup-btn" @click.prevent="togglePopup"></a>
    <a href="#" v-if="showGeneralDetail" class="close-popup-btn" @click.prevent="closeWindow"></a>
    <h5>Продано на суму</h5>
    <div class="divider"
         :style="{
           'opacity': (showPopupDetail || showGeneralDetail) ? 0 : 1
         }"></div>
    <div class="total-show-more">
      <h2>{{details.allTicketSum | thousant}}</h2>
      <a href="#" class="show-more" v-if="!showPopupDetail && !showGeneralDetail" @click.prevent="togglePopup">Дізнатись більше</a>
    </div>
    <div class="total-soulds__more-inf" v-if="showGeneralDetail">
      <ul class="left-side">
        <li>
          <h5>{{detail[0].title}}</h5>
          <p><span>{{detail[0].total | thousant}}</span>грн <span>{{isNaN(detail[0].percents) ? 0 : detail[0].percents}}%</span></p>
        </li>
        <li>
          <h5>{{detail[1].title}}</h5>
          <p><span>{{detail[1].total | thousant}}</span>грн <span>{{isNaN(detail[1].percents) ? 0 : detail[1].percents}}%</span></p>
        </li>
        <li>
          <h5>{{detail[2].title}}</h5>
          <p><span>{{detail[2].total | thousant}}</span>грн <span>{{isNaN(detail[2].percents) ? 0 : detail[2].percents}}%</span></p>
        </li>
      </ul>
      <ul class="right-side">
        <li>
          <h5>{{detail[3].title}}</h5>
          <p><span>{{detail[3].total | thousant}}</span>грн <span>{{isNaN(detail[3].percents) ? 0 : detail[3].percents}}%</span></p>
        </li>
        <li>
          <h5>{{detail[5].title}}</h5>
          <p><span>{{detail[5].total | thousant}}</span>грн</p>
        </li>
      </ul>
    </div>
    <div class="total-soulds__more-inf popup" v-if="showPopupDetail && details">
      <ul>
        <li>
          <h5>Онлайн</h5>
          <p><span>{{details.onlineTicketSum | thousant}}</span>грн <span>{{isNaN(onlinePercents) ? 0 : onlinePercents}}%</span></p>
        </li>
        <li>
          <h5>Офлайн</h5>
          <p><span>{{details.offlineTicketSum | thousant}}</span>грн <span>{{isNaN(offlinePercents) ? 0 : offlinePercents}}%</span></p>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TotalSoulds',
  props: {
    showDetail: Boolean,
    details: Object
  },
  data () {
    return {
      showGeneralDetail: false,
      showPopupDetail: false,
      onlinePercents: 0,
      offlinePercents: 0,
      detail: [
        {
          show: true,
          title: 'Каса:',
          total: 0,
          percents: 0
        },
        {
          show: true,
          title: 'Запрошень:',
          total: 0,
          percents: 0
        },
        {
          show: true,
          title: 'Заброньовано:',
          total: 0,
          percents: 0
        },
        {
          show: true,
          title: 'Онлайн:',
          total: 0,
          percents: 0
        },
        {
          show: true,
          title: 'Офлайн:',
          total: 0,
          percents: 0
        },
        {
          show: true,
          title: 'Не продано:',
          total: 0,
          inQuantity: 0,
          percents: 0
        }
      ]
    }
  },
  updated () {
    if (this.details) {
      this.detail[0].total = this.details.offlineTicketSum
      this.detail[0].percents = (this.details.offlineTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[1].total = this.details.inviteTicketSum
      this.detail[1].percents = (this.details.inviteTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[2].total = this.details.bookedTicketSum
      this.detail[2].percents = (this.details.bookedTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[3].total = this.details.onlineTicketSum
      this.detail[3].percents = (this.details.onlineTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[4].total = this.details.offlineTicketSum
      this.detail[4].percents = (this.details.offlineTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[5].total = this.details.notSoldTicketSum
      this.detail[5].percents = (this.details.notSoldTicketSum * 100 / this.details.allTicketSum).toFixed(2)
    }
  },
  mounted () {
    if (this.details) {
      this.detail[0].total = this.details.offlineTicketSum
      this.detail[0].percents = (+this.details.offlineTicketSum * 100 / +this.details.allTicketSum).toFixed(2)
      this.detail[1].total = this.details.inviteTicketSum
      this.detail[1].percents = (this.details.inviteTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[2].total = this.details.bookedTicketSum
      this.detail[2].percents = (this.details.bookedTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[3].total = this.details.onlineTicketSum
      this.detail[3].percents = (this.details.onlineTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[4].total = this.details.offlineTicketSum
      this.detail[4].percents = (this.details.offlineTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.detail[5].total = this.details.notSoldTicketSum
      this.detail[5].percents = (this.details.notSoldTicketSum * 100 / this.details.allTicketSum).toFixed(2)
      this.showGeneralDetail = this.showDetail
      this.onlinePercents = (100 * this.details.onlineTicketSum / this.details.allTicketSum).toFixed(2)
      this.offlinePercents = (100 * this.details.offlineTicketSum / this.details.allTicketSum).toFixed(2)
    }
  },
  methods: {
    togglePopup () {
      this.showPopupDetail = !this.showPopupDetail
    },
    closeWindow () {
      this.showPopupDetail = false
      this.$store.dispatch('showDetails', { 'show': false })
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
  .total-soulds {
    position: relative;
    z-index: 200;
    width: 100vw;
    max-width: 294px;
    margin: 0 auto;
    padding: 10px 20px 16px;
    border-radius: 10px;
    background-repeat: no-repeat;
    background-size: 100% auto, 100% 100%;
    background-position: 100% 100%, 0 0;
    background-image: url('../assets/total-soulds-bg.svg'), $linear_bg_3;
    box-shadow: 0 3px 6px rgba($shadow-color-2, 0.45);
    .close-popup-btn {
      display: block;
      width: 20px;
      height: 20px;
      background-repeat: no-repeat;
      background-position: 50% 50%;
      background-size: contain;
      background-image: url('../assets/close-popup-icon.svg');
      position: absolute;
      top: 20px;
      right: 14px;
      &:before {
        content: '';
        display: block;
        width: 150%;
        height: 150%;
        position: absolute;
        top: 0;
        left: 0;
        transform: translate(-15%, -15%);
      }
    }
    &:before, &:after {
      content: '';
      display: block;
      width: 0;
      height: 0;
      opacity: 0;
      transition: opacity .3s ease-in-out;
    }
    &.general-detail {
      padding-top: 20px;
      &:after {
        position: absolute;
        top: 0;
        left: 0;
        z-index: 0;
        width: 100%;
        height: 100%;
        background-image: $linear_bg_3;
        border-radius: 10px;
        opacity: 1;
      }
      .total-show-more {
        position: relative;
        &:after {
          content: '';
          display: block;
          width: 145px;
          height: 1px;
          background-repeat: no-repeat;
          background-position: 0 0;
          background-size: 100% 100%;
          background-image: url('../assets/divider-5.svg');
          position: absolute;
          top: calc(100% + 10px);
          left: -20px;
        }
      }
    }
    &.popup-detail {
      padding-top: 20px;
      &:after {
        position: absolute;
        top: 0;
        left: 0;
        z-index: 0;
        width: 100%;
        height: 100%;
        background-image: $linear_bg_3;
        border-radius: 10px;
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
        opacity: 1;
      }
      &:before {
        position: fixed;
        top: 0;
        left: 0;
        z-index: -1;
        width: 100vw;
        height: 100vh;
        background-color: rgba(#161D31, .68);
        opacity: 1;
      }
    }
    * {
      user-select: none;
      position: relative;
      z-index: 1;
    }
    h5 {
      @include fnt(normal, normal);
      font-size: 12px;
      line-height: 12px;
      color: $primary;
      margin: 0;
      padding: 0;
    }
    h2 {
      @include fnt(300, normal);
      font-size: 30px;
      line-height: 30px;
      color: $primary;
      margin: 0;
      padding: 0;
    }
    .divider {
      width: 38px;
      height: 1px;
      background-repeat: no-repeat;
      background-position: 0 0;
      background-size: 100% 100%;
      background-image: url('../assets/divider-1.svg');
      margin: 11px 0 7px;
    }
    .total-show-more {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
    }
    .show-more {
      display: block;
      @include fnt(normal, normal);
      font-size: 12px;
      line-height: 12px;
      color: $secondary;
      margin: 0;
      padding: 0;
      position: relative;
      text-decoration: none;
      &:hover, &:active {
        text-decoration: none;
      }
      &:after {
        content: '';
        display: block;
        width: 83px;
        height: 1px;
        background-repeat: no-repeat;
        background-position: 0 0;
        background-size: 100% 100%;
        background-image: url('../assets/divider-2.svg');
        position: absolute;
        top: 100%;
        right: 0;
        margin-top: 6px;
      }
    }
    &__more-inf {
      display: flex;
      padding: 23px 0 0 0;
      &.popup {
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        padding-left: 20px;
        padding-right: 20px;
        background-image: $linear_bg_3;
        border-bottom-left-radius: 10px;
        border-bottom-right-radius: 10px;
        &:before {
          content: '';
          display: block;
          width: 145px;
          height: 1px;
          background-repeat: no-repeat;
          background-position: 0 0;
          background-size: 100% 100%;
          background-image: url('../assets/divider-5.svg');
          position: absolute;
          top: 0;
          left: 0;
        }
      }
      ul {
        width: 50%;
        margin: 0;
        padding: 0;
        list-style: none;
        li {
          position: relative;
          white-space: nowrap;
          &:before {
            content: '';
            display: block;
            width: 5px;
            height: 1px;
            border-radius: 2;
            background-color: $secondary;
            position: absolute;
            right: 100%;
            top: 6px;
            margin-right: 5px;
          }
          h5 {
            @include fnt(300, normal);
            font-size: 12px;
            line-height: 12px;
            color: $primary;
            margin: 0;
            padding: 0;
          }
          p {
            margin-top: 4px;
            @include fnt(500, normal);
            font-size: 12px;
            line-height: 14px;
            color: $primary;
            span {
              font-size: 14px;
            }
          }
        }
        &.right-side {
          li {
            text-align: right;
            &:before {
              right: auto;
              left: 100%;
              margin-right: 0;
              margin-left: 5px;
            }
          }
        }
      }
    }
  }
</style>
