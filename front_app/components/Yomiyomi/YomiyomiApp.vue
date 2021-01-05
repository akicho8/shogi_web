<template lang="pug">
client-only
  .YomiyomiApp
    b-sidebar.is-unselectable.YomiyomiApp-Sidebar(fullheight right overlay v-model="sidebar_p")
      .mx-4.my-4
        .is-flex.is-justify-content-start.is-align-items-center
          b-button(@click="sidebar_toggle" icon-left="menu")
        .mt-4
          b-menu
            b-menu-list(label="Action")
              b-menu-item(label="局面編集" @click="mode_toggle_handle" :class="{'has-text-weight-bold': this.sp_run_mode === 'edit_mode'}")

    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold
          | {{current_title}}
      template(slot="end")
        b-navbar-item.has-text-weight-bold(@click="tweet_handle" v-if="sp_run_mode === 'play_mode'")
          b-icon(icon="twitter" type="is-white")
        b-navbar-item.has-text-weight-bold(@click="mode_toggle_handle" v-if="sp_run_mode === 'edit_mode'")
          | 編集完了
        b-navbar-item(@click="sidebar_toggle" v-if="sp_run_mode === 'play_mode'")
          b-icon(icon="menu")

    MainSection.is_mobile_padding_zero
      .container
        .columns.is-centered
          .column(v-if="sp_run_mode === 'play_mode'")
            .buttons.is-centered
              template(v-if="talk_now")
                b-button(@click="yomiage_stop_handle" icon-left="stop")
              template(v-else)
                b-button(@click="yomiage_play_handle" icon-left="play")

          .column.is-8-tablet.is-5-desktop(v-if="sp_run_mode === 'edit_mode'")
            CustomShogiPlayer(
              :sp_run_mode="sp_run_mode"
              :sp_body="sp_body"
              :sp_sound_enabled="true"
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"
              sp_human_side="both"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
            )
    DebugPre {{$data}}
</template>

<script>
const RUN_MODE_DEFAULT = "play_mode"

import _ from "lodash"

import { support_parent } from "./support_parent.js"

import AnySourceReadModal         from "@/components/AnySourceReadModal.vue"

export default {
  name: "YomiyomiApp",
  mixins: [
    support_parent,
  ],
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      yomiage_body: null,
      talk_now: false,

      sp_body: null,
      current_title:       "目隠し将棋",               // 現在のタイトル

      sp_run_mode: "play_mode",

      sidebar_p: false,
    }
  },
  created() {
    this.sp_body = this.$route.query.body || "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
  },
  mounted() {
    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.sp_body,
    ], () => {
      this.$router.replace({query: this.current_url_params}).catch(e => {})
    })
  },
  methods: {
    async yomiage_play_handle() {
      if (!this.yomiage_body) {
        await this.$axios.$post("/api/yomiyomi.json", {sfen: this.sp_body}).then(e => {
          if (e.bs_error) {
            this.bs_error_message_dialog(e.bs_error)
          }
          if (e.yomiage) {
            this.yomiage_body = e.yomiage_body
          }
        })
      }
      if (this.yomiage_body) {
        this.talk_stop()
        this.talk_now = true
        this.talk(this.yomiage_body, {rate: 1.0, onend: () => this.talk_now = false})
      }
    },

    yomiage_stop_handle() {
      this.talk_stop()
      this.talk_now = false
    },

    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },

    edit_mode_snapshot_sfen_set(v) {
      if (this.sp_run_mode === "edit_mode") { // 操作モードでも呼ばれるから
        this.sp_body = v
      }
    },

    tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body})
    },

    // 操作←→編集 切り替え
    mode_toggle_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      if (this.sp_run_mode === "play_mode") {
        this.sp_run_mode = "edit_mode"
        this.yomiage_body = null
      } else {
        this.sp_run_mode = "play_mode"
      }
    },

    // ../../../app/controllers/yomiyomis_controller.rb の current_og_image_path と一致させること
    permalink_for(params = {}) {
      let url = null
      url = new URL(this.$config.MY_SITE_URL + `/yomiyomi`)

      params = {
        ...this.current_url_params,
        ...params,
      }

      _.each(params, (v, k) => {
        url.searchParams.set(k, v)
      })

      return url.toString()
    },
  },

  computed: {
    current_url_params() {
      const params = {
        body: this.sp_body,
      }
      return params
    },

    // URL
    current_url() { return this.permalink_for() },

    ////////////////////////////////////////////////////////////////////////////////

    tweet_body() {
      let o = ""
      o += "\n"
      o += "#" + this.current_title
      o += "\n"
      o += this.current_url
      return o
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .YomiyomiApp
    .CustomShogiPlayer
    .ShogiPlayerGround
    .ShogiPlayerWidth
    .Membership
      border: 1px dashed change_color($success, $alpha: 0.5)

.YomiyomiApp-Sidebar
  // .sidebar-content
  //   width: unset

  // .menu-label:not(:first-child)
  //   margin-top: 1.5em
  .menu-label
    margin-top: 2em

.YomiyomiApp
  .MainSection.section
    +mobile
      padding: 0.75rem 0 0

  .EditToolBlock
    margin-top: 12px
</style>
