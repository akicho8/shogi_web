<template lang="pug">
client-only
  .BlindfoldApp
    b-sidebar.is-unselectable.BlindfoldApp-Sidebar(fullheight right overlay v-model="sidebar_p")
      .mx-4.my-4
        .is-flex.is-justify-content-start.is-align-items-center
          b-button(@click="sidebar_toggle" icon-left="menu")
        .mt-4
          b-menu
            b-menu-list(label="Action")
              b-menu-item(label="局面編集" @click="mode_toggle_handle")
              //- b-menu-item(label="Tweet"    @click="tweet_handle")

    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'blindfold'}") {{current_title}}
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
            .buttons.is-centered.are-medium
              template(v-if="talk_now")
                b-button(@click="stop_handle" icon-left="stop")
              template(v-else)
                b-button(@click="play_handle" icon-left="play")

          .column.is-8-tablet.is-5-desktop(v-if="sp_run_mode === 'edit_mode'")
            CustomShogiPlayer(
              :sp_body="sp_body"
              :sp_sound_enabled="true"
              sp_run_mode="edit_mode"
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

export default {
  name: "BlindfoldApp",
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
      current_title: "目隠し詰将棋",
      sp_run_mode: "play_mode",
      sidebar_p: false,
    }
  },
  created() {
  },
  mounted() {
    this.$watch(() => [
      this.sp_body,
    ], () => {
      this.$router.replace({query: this.current_url_params}).catch(e => {})
    })
    this.sp_body = this.$route.query.body || "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
  },
  methods: {
    async play_handle() {
      if (!this.yomiage_body) {
        await this.$axios.$post("/api/blindfold.json", {sfen: this.sp_body}).then(e => {
          if (e.bs_error) {
            this.bs_error_message_dialog(e.bs_error)
          }
          if (e.yomiage_body) {
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

    stop_handle() {
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
      this.yomiage_body = null
      if (this.sp_run_mode === "play_mode") {
        this.sp_run_mode = "edit_mode"
      } else {
        this.sp_run_mode = "play_mode"
      }
    },
  },

  computed: {
    current_url_params() {
      return {
        body: this.sp_body,
      }
    },
    current_url() {
      let url = new URL(this.$config.MY_SITE_URL + `/blindfold`)
      _.each(this.current_url_params, (v, k) => {
        url.searchParams.set(k, v)
      })
      return url.toString()
    },
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
  .BlindfoldApp
    .CustomShogiPlayer
    .ShogiPlayerGround
    .ShogiPlayerWidth
    .Membership
      border: 1px dashed change_color($success, $alpha: 0.5)

.BlindfoldApp-Sidebar
  .menu-label
    margin-top: 2em

.BlindfoldApp
  .buttons
    .button
      min-width: 6rem

  .MainSection.section
    +mobile
      padding: 4rem 0 0
  .EditToolBlock
    margin-top: 12px
</style>
