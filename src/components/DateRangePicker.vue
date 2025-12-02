<template>
  <div class="date-range-picker-popup" v-if="show">
    <div class="date-range-picker-popup__window">
      <i class="close-picker-popup" @click.prevent="closePopup"></i>
      <h3>{{title || 'Оберіть проміжок:'}}</h3>
      <div class="date-labels">
        <label>Від: <span>{{formatDisplayDate(dateFrom) || '___-__-__'}}</span></label>
        <label>До: <span>{{formatDisplayDate(dateTo) || '___-__-__'}}</span></label>
      </div>
      
      <!-- Custom Calendar -->
      <div class="calendar">
        <div class="calendar-header">
          <button @click.prevent="previousMonth" class="calendar-nav">‹</button>
          <span class="calendar-month">{{monthName}} {{currentYear}}</span>
          <button @click.prevent="nextMonth" class="calendar-nav">›</button>
        </div>
        <div class="calendar-weekdays">
          <div v-for="day in weekDays" :key="day" class="calendar-weekday">{{day}}</div>
        </div>
        <div class="calendar-days">
          <div
            v-for="day in calendarDays"
            :key="day.key"
            :class="getDayClass(day)"
            @click="selectDate(day)"
          >
            {{day.date}}
          </div>
        </div>
      </div>
      
      <button @click.prevent="submitRange" class="btn-submit">Підтвердити</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DateRangePicker',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: 'Оберіть проміжок:'
    },
    initialRange: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      dateFrom: this.initialRange?.from || null,
      dateTo: this.initialRange?.to || null,
      currentMonth: new Date().getMonth(),
      currentYear: new Date().getFullYear(),
      weekDays: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд'],
      monthNames: ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 
                   'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень']
    }
  },
  computed: {
    monthName () {
      return this.monthNames[this.currentMonth]
    },
    calendarDays () {
      const days = []
      const firstDay = new Date(this.currentYear, this.currentMonth, 1)
      const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0)
      
      // Adjust for Monday start (0 = Sunday -> 6, 1 = Monday -> 0)
      let startPadding = firstDay.getDay() - 1
      if (startPadding === -1) startPadding = 6
      
      // Add empty days for padding
      for (let i = 0; i < startPadding; i++) {
        days.push({ date: '', disabled: true, key: `empty-${i}` })
      }
      
      // Add actual days
      for (let i = 1; i <= lastDay.getDate(); i++) {
        days.push({
          date: i,
          disabled: false,
          fullDate: this.formatDate(new Date(this.currentYear, this.currentMonth, i)),
          key: `day-${i}`
        })
      }
      
      return days
    }
  },
  watch: {
    initialRange (newVal) {
      this.dateFrom = newVal?.from || null
      this.dateTo = newVal?.to || null
    }
  },
  methods: {
    formatDate (date) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    formatDisplayDate (dateStr) {
      if (!dateStr) return ''
      const parts = dateStr.split('-')
      return `${parts[2]}.${parts[1]}.${parts[0]}`
    },
    selectDate (day) {
      if (day.disabled || !day.fullDate) return
      
      if (!this.dateFrom || (this.dateFrom && this.dateTo)) {
        // Start new selection
        this.dateFrom = day.fullDate
        this.dateTo = null
      } else if (this.dateFrom && !this.dateTo) {
        // Complete the range
        if (day.fullDate >= this.dateFrom) {
          this.dateTo = day.fullDate
        } else {
          // If selected date is before start, swap them
          this.dateTo = this.dateFrom
          this.dateFrom = day.fullDate
        }
      }
    },
    getDayClass (day) {
      if (day.disabled) return 'calendar-day disabled'
      
      const classes = ['calendar-day']
      
      if (day.fullDate === this.dateFrom) {
        classes.push('start')
      }
      if (day.fullDate === this.dateTo) {
        classes.push('end')
      }
      if (this.dateFrom && this.dateTo && day.fullDate > this.dateFrom && day.fullDate < this.dateTo) {
        classes.push('in-range')
      }
      
      return classes.join(' ')
    },
    previousMonth () {
      if (this.currentMonth === 0) {
        this.currentMonth = 11
        this.currentYear--
      } else {
        this.currentMonth--
      }
    },
    nextMonth () {
      if (this.currentMonth === 11) {
        this.currentMonth = 0
        this.currentYear++
      } else {
        this.currentMonth++
      }
    },
    submitRange () {
      if (this.dateFrom && this.dateTo) {
        this.$emit('submit', {
          from: this.dateFrom,
          to: this.dateTo
        })
        this.closePopup()
      }
    },
    closePopup () {
      this.$emit('close')
    }
  }
}
</script>

<style lang="scss">
  @import '../css/quasar.variables';

  .date-range-picker-popup {
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
      max-width: 350px;
      padding: 15px;
      border-radius: 15px;
      .close-picker-popup {
        display: block;
        width: 20px;
        height: 20px;
        background-repeat: no-repeat;
        background-position: 50% 50%;
        background-size: contain;
        background-image: url('../assets/close-popup-icon.svg');
        margin-left: auto;
        cursor: pointer;
      }
      h3 {
        font-size: 20px;
        line-height: 20px;
        text-align: center;
        margin: 0 0 15px;
        padding: 0;
      }
      .date-labels {
        display: flex;
        justify-content: space-between;
        margin-bottom: 15px;
        label {
          font-size: 16px;
          span {
            display: inline-block;
            border: 1px solid #fff;
            padding: 3px;
            border-radius: 3px;
          }
        }
      }
      .calendar {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 8px;
        padding: 10px;
        color: #333;
        margin-bottom: 15px;
        
        .calendar-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 10px;
          
          .calendar-nav {
            background: none;
            border: none;
            font-size: 20px;
            color: #333;
            cursor: pointer;
            padding: 5px 10px;
            &:active {
              opacity: 0.6;
            }
          }
          
          .calendar-month {
            font-size: 16px;
            font-weight: bold;
          }
        }
        
        .calendar-weekdays {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          gap: 2px;
          margin-bottom: 5px;
          
          .calendar-weekday {
            text-align: center;
            font-size: 12px;
            font-weight: bold;
            color: #666;
            padding: 5px 0;
          }
        }
        
        .calendar-days {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          gap: 2px;
          
          .calendar-day {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            background: #fff;
            transition: all 0.2s ease;
            
            &:not(.disabled):active {
              background: #e0e0e0;
            }
            
            &.disabled {
              background: transparent;
              cursor: default;
            }
            
            &.start, &.end {
              background: $secondary;
              color: #fff;
              font-weight: bold;
            }
            
            &.in-range {
              background: rgba($secondary, 0.2);
              color: #333;
            }
          }
        }
      }
      
      button.btn-submit {
        display: block;
        border: none;
        background-color: transparent;
        outline: none;
        @include fnt(normal, normal);
        font-size: 12px;
        color: $secondary;
        padding: 0;
        margin: 0 auto;
        width: 150px;
      }
    }
  }
</style>

