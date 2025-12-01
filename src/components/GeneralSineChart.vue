<template>
  <div class="general-sine-charts" ref="sine-charts-container">
    <TrendChart ref="charts"
                :padding="'22 30'"
                :datasets="dataset"
    ></TrendChart>
    <div class="chart-dots-container"
         :style="{
           'width': 100 * Math.ceil(points.length / dotsPerView) + '%'
         }">
      <svg class="dots" ref="chart-dots" width="100%" height="100%" :key="dotsUpdateKey">
        <g class="chart-dots">
          <circle v-for="(c, ci) in dots" :key="'dot-' + ci"
                  :r="c.active ? 6 : 5"
                  fill="#313D5F" stroke-width="2"
                  :cx="c.x" :cy="c.y" class="show" :class="{
                    'active': c.active
                  }"
                  @click.prevent="onMarkerClick(ci)"></circle>
          <text v-for="(l, li) in labels" :key="'label-' + li"
                :x="l.x" :y="l.y"
                :class="{
                  'to-bottom': li % 2 === 0,
                  'active': l.active
                }"
                @click.prevent="onMarkerClick(li)">{{l.title}}</text>
        </g>
      </svg>
    </div>
  </div>
</template>

<script>
export default {
  name: 'GeneralSineCharts',
  props: {
    points: Array
  },
  data () {
    return {
      dotsUpdateKey: 'dots-update-key-' + new Date(),
      dots: [],
      labels: [],
      dataset: [],
      dotsPerView: 7.5
    }
  },
  mounted () {
    this.$refs['charts'].width = this.$refs['charts'].width * Math.ceil(this.points.length / this.dotsPerView)
    this.$refs['charts'].$el.width.baseVal.value = this.$refs['charts'].$el.width.baseVal.value * Math.ceil(this.points.length / this.dotsPerView)
    this.generatePoints()
    this.$store.watch(
      (state, getters) => getters.isDetailsShow,
      (newValue, oldValue) => {
        if (!newValue) {
          this.dotsUpdateKey += 1
        }
      }
    )
  },
  methods: {
    onMarkerClick (i) {
      this.$store.dispatch('showDetails', { 'show': true })
      this.activeMarker(i)
      this.$emit('marker-click', this.labels[i].title)
    },
    activeMarker (markerIndex) {
      this.dots.forEach(item => {
        item.active = false
      })
      this.labels.forEach(item => {
        item.active = false
      })
      this.dots[markerIndex].active = true
      this.labels[markerIndex].active = true
      this.dotsUpdateKey += 1
    },
    generateDots () {
      this.dots = []
      let circles = this.$refs['charts'].$el.childNodes[0].childNodes[1].childNodes
      for (let i = 0; i < circles.length; i++) {
        let x = circles[i].cx.baseVal.value
        let y = circles[i].cy.baseVal.value
        this.dots.push({ x: x, y: y, active: false })
        this.labels[i].x = x
        this.labels[i].y = y
      }
    },
    generatePoints () {
      this.labels = []
      this.dataset = []
      let arr = []
      for (let i = 0; i < this.points.length; i++) {
        arr.push(this.points[i].y)
        this.labels.push({
          title: this.points[i].x,
          x: 0,
          y: 0,
          active: false
        })
      }
      this.dataset.push({
        data: arr,
        smooth: true,
        fill: false,
        className: 'chart-line',
        showPoints: true
      })
      setTimeout(() => {
        this.generateDots()
      }, 500)
    }
  }
}
</script>

<style lang="scss">
  @import '../css/quasar.variables.scss';
  svg {
    fill: none;
    g, ::v-deep g {
      transition: opacity .3s ease-in-out;
    }
  }
  .general-sine-charts {
    overflow-y: hidden;
    overflow-x: auto;
    position: relative;
    .chart-dots-container {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
    }
    .dots {
      circle {
        display: block;
        &.active {
          stroke: #ffffff;
        }
      }
    }
    ::v-deep .points {
      opacity: 0;
    }
    ::v-deep path {
      stroke-width: 2px;
    }
    ::v-deep .chart-line {
      path {
        stroke: #12BFFF;
      }
    }
    .chart-dots {
      circle {
        stroke: #12BFFF;
        &.active {
          stroke: #ffffff !important;
        }
      }
      text {
        @include fnt(normal, normal);
        font-size: 12px;
        fill: #12BFFF;
        transform: translate(-22px, -12px);
        &.to-bottom {
          transform: translate(-22px, 22px);
        }
        &.active {
          stroke: #ffffff;
          @include fnt(normal, normal);
        }
      }
    }
  }
</style>
