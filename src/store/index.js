import Vue from 'vue'
import Vuex from 'vuex'
import state from './module'

Vue.use(Vuex)

export default function () {
  const Store = new Vuex.Store(
    state
  )

  return Store
}
