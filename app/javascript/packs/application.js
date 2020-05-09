// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "modulable_crud.js"
import "global_variable_set.js"

//////////////////////////////////////////////////////////////////////////////// Vue

import Vue from "vue/dist/vue.esm" // esm版はvueのtemplateをパースできる
window.Vue = Vue

import Vuex from "vuex"
Vue.use(Vuex)                   // これは一箇所だけで実行すること。shogi-player 側で実行すると干渉する

import VueRouter from "vue-router"
Vue.use(VueRouter)

// https://www.npmjs.com/package/vue-dump
import "vue-dump/dist/vue-dump.css"
import VueDump from "vue-dump/dist/vue-dump.common"
Vue.use(VueDump)

import VueGtag from "vue-gtag"
Vue.use(VueGtag, {
  config: {
    id: 'UA-109851345-1',
    params: {
      // send_page_view: process.env.NODE_ENV !== "production",

      // https://developers.google.com/analytics/devguides/collection/gtagjs/cookies-user-id?hl=ja
      // > サーバーがローカル環境（例: localhost）で実行されていることが検出されると、cookie_domain は自動的に 'none' に設定されます
      // cookie_domain: 'none',
    },
  },
})

import Repository from "Repository.js"
Vue.prototype.$http = Repository

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

import "chart_init.js"

////////////////////////////////////////////////////////////////////////////////

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

window.tab_is_active_p = () => {
  console.log("document.hidden", document.hidden)
  console.log("document.visibilityState", document.visibilityState)
  return !(document.hidden || document.visibilityState === "hidden")
}

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい

import LifetimeInfo from "lifetime_info"
import TeamInfo from "team_info"
import LastActionInfo from "last_action_info"
import CustomPresetInfo from "custom_preset_info"
import HiraKomaInfo from "hira_koma_info"
import RobotAcceptInfo from "robot_accept_info"

Vue.prototype.LifetimeInfo = LifetimeInfo
Vue.prototype.TeamInfo = TeamInfo
Vue.prototype.LastActionInfo = LastActionInfo
Vue.prototype.CustomPresetInfo = CustomPresetInfo
Vue.prototype.HiraKomaInfo = HiraKomaInfo
Vue.prototype.RobotAcceptInfo = RobotAcceptInfo

//////////////////////////////////////////////////////////////////////////////// どこからでも使いたい2

import vue_application from "support/vue_application.js"
import vue_support from "support/vue_support.js"
import vue_storage from "support/vue_storage.js"
import vue_fetch from "support/vue_fetch.js"
import vue_clipboard from "support/vue_clipboard.js"
import vue_sound from "support/vue_sound.js"
import vue_actioncable from "support/vue_actioncable.js"

import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"
import message_link_to from "message_link_to.vue"
import global_message_link from "global_message_link.vue"
import swars_user_link_to from "swars_user_link_to.vue"
import pulldown_menu from "pulldown_menu.vue"
import buefy_table_wrapper from "buefy_table_wrapper.vue"
import three_stage_league_player_chart from "three_stage_league_player_chart.vue"
import custom_chart from "custom_chart.vue"
import acns1_sample from "acns1_sample.vue"
import acns2_sample from "acns2_sample.vue"
import actf_app from "actf_app"
import stopwatch from "stopwatch.vue"
import simple_board from "simple_board.vue"
import share_board from "share_board.vue"
import xy_master from "xy_master.vue"
import cpu_battle from "cpu_battle.vue"
import sp_show from "sp_show.vue"
import ox_modal from "ox_modal.vue"
import tactic_show from "tactic_show.vue"
import piyo_shogi_button from "components/piyo_shogi_button.vue"
import kento_button from "components/kento_button.vue"
import kif_copy_button from "components/kif_copy_button.vue"
import sp_show_button from "components/sp_show_button.vue"
import png_dl_button from "components/png_dl_button.vue"
import tweet_button from "components/tweet_button.vue"
import membership_medal from "components/membership_medal.vue"
import debug_print from "components/debug_print.vue"
import win_lose_circle from "win_lose_circle.vue"

// const router = new VueRouter({
//   mode: 'history',
//   // base: process.env.BASE_URL,
//   // linkActiveClass: "is-active", // router-link-exact-active
//   routes: [
//   ],
// })

Vue.mixin({
  router: new VueRouter({mode: "history"}),

  mixins: [
    vue_application,
    vue_support,
    vue_storage,
    vue_fetch,
    vue_clipboard,
    vue_sound,
    vue_actioncable,
  ],

  // よくない命名規則だけどこっちの方が開発しやすい
  components: {
    shogi_player,
    message_link_to,
    global_message_link,
    swars_user_link_to,
    pulldown_menu,
    stopwatch,
    simple_board,
    share_board,
    xy_master,
    cpu_battle,
    sp_show,
    ox_modal,
    win_lose_circle,
    buefy_table_wrapper,
    three_stage_league_player_chart,
    custom_chart,
    acns1_sample,
    acns2_sample,
    actf_app,

    // for buefy modal
    tactic_show,

    // buttons
    piyo_shogi_button,
    kento_button,
    kif_copy_button,
    sp_show_button,
    png_dl_button,
    tweet_button,
    debug_print,

    // icon
    membership_medal,
  },
})

window.GVI = new Vue()           // ActionCable 側から Vue のグローバルなメソッドを呼ぶため

import "audio_queue.js"
import "light_session_app.js"

window.App = {}
