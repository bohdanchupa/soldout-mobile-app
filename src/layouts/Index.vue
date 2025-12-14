<template>
  <q-layout view="lHh Lpr lff">
    <q-page-container>
      <transition name="slide" mode="out-in">
        <router-view :key="updateKey"></router-view>
      </transition>
    </q-page-container>
    <q-footer v-if="getAccessToken" class="footer">
      <span class="deco deco--left"></span>
      <span class="deco deco--right"></span>
      <q-toolbar class="row justify-between">
        <router-link
          v-for="(navItem, index) in nav"
          :key="index"
          class="footer__nav-link"
          :class="[navItem.id, {
            'router-link-active': navItem.active
          }]"
          :to="navItem.link">
          <span class="icon">
            <q-icon :name="'img:' + navItem.icon"></q-icon>
          </span>
          <span class="title">
            {{navItem.title}}
          </span>
        </router-link>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script>
export default {
  name: 'Index',
  data () {
    return {
      updateKey: 'route-key-1',
      nav: [
        {
          id: 'entry',
          title: 'Сьогодні',
          icon: require('assets/footer-today.svg'),
          link: '/entry',
          active: false
        },
        {
          id: 'today',
          title: 'Події (сьогодні)',
          icon: require('assets/footer-all.svg'),
          link: '/list-of-events/today',
          active: false
        },
        {
          id: 'general',
          title: 'Загальні',
          icon: require('assets/footer-general.svg'),
          link: '/list-of-events/general',
          active: false
        },
        {
          id: 'profile',
          title: 'Профіль',
          icon: require('assets/footer-profile.svg'),
          link: '/profile',
          active: false
        },
        {
          id: 'archive',
          title: 'Архів',
          icon: require('assets/footer-archive.svg'),
          link: '/list-of-events/archive',
          active: false
        }
      ]
    }
  },
  beforeRouteUpdate (to, from, next) {
    this.nav.forEach(item => {
      item.active = false
    })
    if (from.params.listId && to.params.eventId) {
      this.nav.filter(item => item.id === from.params.listId)[0].active = true
    }
    this.updateKey += '1'
    next()
  },
  created () {
    if (!this.$store.getters.getAccessToken) {
      this.$router.push({
        path: '/'
      })
      this.$store.dispatch('fetchingData', { isFetching: false })
    }
  },
  computed: {
    getAccessToken () {
      return this.$store.getters.getAccessToken
    }
  }
}
</script>

<style lang="scss">
  @import "../css/quasar.variables";
  .slide-enter-active, .slide-leave-active {
    transition: opacity .3s, transform .3s;
  }
  .slide-enter, .slide-leave-to {
    opacity: 0;
    transform: translateX(-30%);
  }
  .footer {
    background-color: $bg-solid-color;
    padding: 8px 15px;
    /* Footer is part of flex layout - stays at bottom, never scrolls */
    /* Position is handled by flex layout in general.scss */
    z-index: 1000 !important;
    transform: translate3d(0, 0, 0) !important;
    -webkit-transform: translate3d(0, 0, 0) !important;
    backface-visibility: hidden !important;
    -webkit-backface-visibility: hidden !important;
    &:before {
      content: '';
      display: block;
      position: absolute;
      height: 8px;
      left: 50px;
      right: 50px;
      top: 0;
      box-shadow: 0 -2px 2px rgba($shadow-color, .25);
    }
    .deco {
      display: block;
      width: 50px;
      height: 50px;
      overflow: hidden;
      position: absolute;
      bottom: 100%;
      &--left {
        left: 0;
        &:before {
          left: 0;
        }
      }
      &--right {
        right: 0;
        &:before {
          right: 0;
        }
      }
      &:before {
        content: '';
        display: block;
        width: 200%;
        height: 200%;
        position: absolute;
        top: -100%;
        border-radius: 50%;
        box-shadow: 0 0 0 60px $bg-solid-color, inset 0 0 6px rgba($shadow-color, .5);
      }
    }
    .q-toolbar {
      display: flex;
      justify-content: space-between;
      align-items: stretch;
      width: 100%;
      padding: 0;
    }
    &__nav-link {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      text-decoration: none;
      /* Рівномірний розподіл ширини - кожна кнопка займає однаково */
      flex: 1 1 0;
      min-width: 0; /* Дозволяє flex працювати правильно */
      padding: 4px 2px;
      /* Prevent movement */
      transform: translateZ(0);
      -webkit-transform: translateZ(0);
      .icon {
        display: flex;
        justify-content: center;
        align-items: center;
        min-width: 28px;
        width: 28px;
        height: 28px;
        margin: 0 auto 4px;
        border: 1px solid transparent;
        border-radius: 50%;
        transition: border-color .3s ease-in-out;
        flex-shrink: 0;
      }
      &.router-link-active {
        .icon {
          border-color: $secondary;
        }
        .title {
          font-weight: normal;
        }
      }
      .title {
        @include fnt(300, normal);
        font-size: 10px;
        line-height: 12px;
        color: $primary;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 100%;
      }
      img {
        height: auto;
      }
      &.entry {
        img {
          width: 18px;
        }
      }
      &.today {
        img {
          width: 13px;
        }
      }
      &.general {
        img {
          width: 16px;
        }
      }
      &.profile {
        img {
          width: 13px;
        }
      }
      &.archive {
        img {
          width: 16px;
        }
      }
    }
  }
</style>
