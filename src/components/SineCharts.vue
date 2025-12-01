<template>
  <div class="sine-charts" ref="sine-charts-container" :class="['active-line-' + activeLine]">
    <TrendChart ref="charts"
      :padding="'25 0'"
      :datasets="points"
    ></TrendChart>
    <svg class="dots" ref="chart-dots" width="100%" height="100%" :key="dotsUpdateKey">
      <g v-for="(g, gi) in dots" :key="gi" :class="['chart-dot-' + (gi + 1)]">
        <circle v-for="(c, ci) in g" :key="ci"
                v-show="ci > 0 && ci < g.length - 1"
                :r="c.active ? 6 : 5"
                fill="#313D5F" stroke-width="2"
                :cx="c.x" :cy="c.y" :class="{
                  'show-first': c.showFirst,
                  'show': showAllMarkers[gi],
                  'active': c.active
                }" @click.prevent="onMarkerClick(gi, ci)"></circle>
      </g>
      <g class="first-labels" v-if="firstLabels.length > 0">
        <text v-for="(t, ti) in firstLabels" :key="ti" :x="t.x" :y="t.y" @click.prevent="onMarkerClick(ti, 1)">{{t.title}}</text>
      </g>
      <g class="labels" v-for="(gl, gli) in labels" :key="'labels-group-' + gli" :class="['labels-' + gli]">
        <text v-for="(l, li) in gl" :key="'label-' + li" :x="l.x" :y="l.y" @click.prevent="onMarkerClick(gli, li)"
              v-show="li > 0 && li < gl.length - 1"
              :class="{
                'to-bottom': li % 2 === 0,
                'active': l.active
              }">{{l.title}}</text>
      </g>
    </svg>
  </div>
</template>

<script>
export default {
  name: 'SineCharts',
  props: {
    charts: Array
  },
  data () {
    return {
      showAllMarkers: [false, false, false],
      dotsUpdateKey: 'dots-update-key-' + new Date(),
      activeLine: -1,
      points: [],
      dots: [],
      labels: [],
      firstLabels: [
        {
          title: 'Квитки',
          x: 0,
          y: 0
        },
        {
          title: 'Замовлено',
          x: 0,
          y: 0
        },
        {
          title: 'Сума',
          x: 0,
          y: 0
        }
      ]
    }
  },
  mounted () {
    this.generatePoints()
    this.$store.watch(
      (state, getters) => getters.isDetailsShow,
      (newValue, oldValue) => {
        if (!newValue) {
          this.showAllMarkers = [false, false, false]
          this.dotsUpdateKey += 1
          this.activeLine = -1
        }
      }
    )
  },
  methods: {
    onMarkerClick (gi, ci) {
      if (this.activeLine === -1) {
        this.showAllMarkers[gi] = !this.showAllMarkers[gi]
        this.dotsUpdateKey += 1
        this.activeLine = gi
        /* this.activeMarker(this.activeLine, ci)
        this.$emit('marker-click', this.labels[this.activeLine][ci].title) */
      }
      if (this.activeLine > -1) {
        this.$store.dispatch('showDetails', { 'show': true })
        this.activeMarker(gi, ci)
        this.$emit('marker-click', this.labels[gi][ci].title)
      }
    },
    activeMarker (groupOfMarkersIndex, markerIndex) {
      this.dots.forEach(item => {
        item.forEach(subItem => { subItem.active = false })
      })
      this.labels.forEach(item => {
        item.forEach(subItem => { subItem.active = false })
      })
      this.dots[groupOfMarkersIndex][markerIndex].active = true
      this.labels[groupOfMarkersIndex][markerIndex].active = true
      this.dotsUpdateKey += 1
    },
    generateDots () {
      this.dots = []
      let childs = this.$refs['charts'].$el.childNodes
      for (let i = 0; i < childs.length; i++) {
        let circles = childs[i].childNodes[1].childNodes
        this.dots.push([])
        for (let j = 0; j < circles.length; j++) {
          let x = circles[j].cx.baseVal.value
          let y = circles[j].cy.baseVal.value
          if (j === circles.length - 2 - i) {
            this.dots[i].push({ x: x, y: y, showFirst: true, active: false })
            this.firstLabels[i].x = x
            this.firstLabels[i].y = y
          } else {
            this.dots[i].push({ x: x, y: y, showFirst: false })
          }
        }
      }
      for (let i = 0; i < this.dots.length; i++) {
        for (let j = 0; j < this.dots[i].length; j++) {
          this.labels[i][j].x = this.dots[i][j].x
          this.labels[i][j].y = this.dots[i][j].y
        }
      }
    },
    generatePoints () {
      this.points = []
      this.labels = []
      for (let i = 0; i < this.charts.length; i++) {
        let arr = []
        let labelsGroup = []
        for (let j = 0; j < this.charts[i].points.length; j++) {
          arr.push(this.charts[i].points[j].y)
          if (this.charts[i].points[j]) {
            labelsGroup.push({
              title: this.charts[i].points[j].x,
              x: 0,
              y: 0,
              active: false
            })
          } else {
            labelsGroup.push({
              title: '',
              x: 0,
              y: 0,
              active: false
            })
          }
        }
        this.labels.push(labelsGroup)
        this.points.push({
          data: arr,
          smooth: true,
          fill: false,
          className: 'chart-line-' + (i + 1),
          showPoints: true
        })
      }
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
  .sine-charts {
    overflow-y: hidden;
    overflow-x: auto;
    position: relative;
    &.active-line-0 {
      .labels-0 {
        display: block;
      }
      ::v-deep {
        .chart-line-1 {
          path {
            stroke: #12BFFF;
          }
        }
        .chart-line-2, .chart-line-3 {
          opacity: 0.1;
        }
      }
      .chart-dot-2, .chart-dot-3 {
        opacity: 0.1;
      }
      .chart-dot-1 {
        circle {
          stroke: #12BFFF;
        }
      }
      .first-labels {
        display: none;
      }
    }
    &.active-line-1 {
      .labels-1 {
        display: block;
      }
      ::v-deep {
        .chart-line-2 {
          path {
            stroke: #FF608E;
          }
        }
        .chart-line-1, .chart-line-3 {
          opacity: 0.1;
        }
      }
      .chart-dot-1, .chart-dot-3 {
        opacity: 0.1;
      }
      .chart-dot-2 {
        circle {
          stroke: #FF608E;
        }
      }
      .first-labels {
        display: none;
      }
    }
    &.active-line-2 {
      .labels-2 {
        display: block;
      }
      ::v-deep {
        .chart-line-1, .chart-line-2 {
          opacity: 0.1;
        }
        .chart-line-3 {
          path {
            stroke: #66E8CD;
          }
        }
      }
      .chart-dot-3 {
        circle {
          stroke: #66E8CD;
        }
      }
      .chart-dot-1, .chart-dot-2 {
        opacity: 0.1;
      }
      .first-labels {
        display: none;
      }
    }
    .dots {
      position: absolute;
      top: 0;
      left: 0;
      circle {
        display: none;
        &.show-first, &.show {
          display: block;
        }
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
    ::v-deep .chart-line-1 {
      path {
        stroke: rgba(#12BFFF, .6);
      }
    }
    ::v-deep .chart-line-2 {
      path {
        stroke: rgba(#FF608E, .6);
      }
    }
    ::v-deep .chart-line-3 {
      path {
        stroke: rgba(#66E8CD, .6);
      }
    }
    .chart-dot-1 {
      circle {
        stroke: rgba(#12BFFF, .6);
      }
    }
    .chart-dot-2 {
      circle {
        stroke: rgba(#FF608E, .6);
      }
    }
    .chart-dot-3 {
      circle {
        stroke: rgba(#66E8CD, .6);
      }
    }
    .active {
      circle {
        stroke: #ffffff !important;
      }
    }
    .labels {
      display: none;
      text {
        @include fnt(normal, normal);
        font-size: 12px;
        fill: #fff;
        transform: translate(-22px, -12px);
        &.to-bottom {
          transform: translate(-22px, 22px);
        }
        &.active {
          stroke: #ffffff;
          @include fnt(normal, normal);
        }
      }
      &-0 {
        text {
          fill: #12BFFF;
        }
      }
      &-1 {
        text {
          fill: #FF608E;
        }
      }
      &-2 {
        text {
          fill: #66E8CD;
        }
      }
    }
    .first-labels {
      text {
        @include fnt(normal, normal);
        font-size: 12px;
        fill: #fff;
        &:nth-child(1) {
          transform: translate(-23px, -10px);
          fill: #12BFFF;
          text-shadow: 0 0 6px rgba(#12BFFF, .4);
        }
        &:nth-child(2) {
          transform: translate(-33px, -10px);
          fill: #FF608E;
          text-shadow: 0 0 6px rgba(#66E8CD, .4);
        }
        &:nth-child(3) {
          transform: translate(-18px, 18px);
          fill: #66E8CD;
          text-shadow: 0 0 6px rgba(#FF608E, .4);
        }
      }
    }
  }
</style>
