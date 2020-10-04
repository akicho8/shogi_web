// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "modulable_crud.js"

//////////////////////////////////////////////////////////////////////////////// Vue

// async を使うと regeneratorRuntime is not defined になる対策
// よくわからんが .babelrc に書くのではなダメだった
import "babel-polyfill"

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

import VueRouter from "vue-router"
Vue.use(VueRouter)

import "css-browser-selector"   // 読み込んだ時点で htmlタグの class に "mobile" などを付与してくれる

//////////////////////////////////////////////////////////////////////////////// Buefy

import "stylesheets/application.sass"
import "bulma_burger.js"

import Buefy from "buefy"
// import "buefy/src/scss/buefy-build.scss" // これか
// import 'buefy/dist/buefy.css'            // これを入れると buefy の初期値に戻ってしまうので注意
Vue.use(Buefy, {
  // https://buefy.org/documentation/constructor-options/
  defaultTooltipType: "is-dark", // デフォルトは背景が明るいため黒くしておく
  defaultTooltipAnimated: true,   // ←効いてなくね？
})

//////////////////////////////////////////////////////////////////////////////// lodash

import _ from "lodash"
window._ = _

//////////////////////////////////////////////////////////////////////////////// Chart.js

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector("#flash_danger_notify_tag")) {
    new Vue({
      el: "#flash_danger_notify_tag",
    })
  }
  if (toast_flash) {
    _.forIn(toast_flash, (message, key) => {
      Vue.prototype.$buefy.toast.open({message: message, position: "is-bottom", type: `is-${key}`, duration: 1000 * 3, queue: false})
    })
  }
})

//////////////////////////////////////////////////////////////////////////////// タブがアクティブか？(見えているか？)

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい2

// Components
import acns1_sample from "acns1_sample.vue"

Vue.mixin({
  router: new VueRouter({mode: "history"}),
  components: {
    acns1_sample,
  },
})
