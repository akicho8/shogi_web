<template lang="pug">
client-only
  .YomiyomiApp
    | {{current_sfen}}
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
                b-button(@click="stop_handle" icon-left="stop")
              template(v-else)
                b-button(@click="saisei_handle" icon-left="play")

          .column.is-8-tablet.is-5-desktop(v-if="sp_run_mode === 'edit_mode'")
            CustomShogiPlayer(
              :sp_run_mode="sp_run_mode"
              :sp_body="current_sfen"
              :sp_sound_enabled="true"
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"
              sp_human_side="both"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
              @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
              @update:turn_offset="v => turn_offset = v"
              @update:turn_offset_max="v => turn_offset_max = v"
            )
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

      current_sfen:        this.defval(this.$route.query.body, "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"),
      current_title:       "目隠し将棋",               // 現在のタイトル
      turn_offset:         this.config.record.initial_turn,        // 現在の手数
      abstract_viewpoint: this.config.record.abstract_viewpoint, // Twitter画像の向き

      // urlには反映しない
      turn_offset_max: null,                         // 最後の手数

      record: this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      sp_run_mode: this.defval(this.$route.query.sp_run_mode, RUN_MODE_DEFAULT),  // 操作モードと局面編集モードの切り替え用
      current_sfen: null,     // 局面編集モードの局面

      sidebar_p: false,
    }
  },
  mounted() {
    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.sp_run_mode,
      this.current_sfen,
      this.current_sfen,      // 編集モード中でもURLを変更したいため
      this.turn_offset,
      this.abstract_viewpoint,
      this.room_code,
    ], () => {
      // 両方エラーになってしまう
      //   this.$router.replace({name: "share-board", query: this.current_url_params})
      //   this.$router.replace({query: this.current_url_params})
      // パラメータだけ変更するときは変更してくれるけどエラーになるっぽいのでエラーにぎりつぶす(いいのか？)
      this.$router.replace({query: this.current_url_params}).catch(e => {
        if (this.development_p) {
          console.debug(e)
        }
      })
    })
  },
  methods: {
    async saisei_handle() {
      if (!this.yomiage_body) {
        await this.$axios.$post("/api/yomiyomi.json", {sfen: this.current_sfen}).then(e => {
          if (e.bs_error) {
            this.bs_error_message_dialog(e.bs_error)
          }
          if (e.yomiage) {
            this.yomiage_body = e.yomiage
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

    // this.sfen_share(this.current_sfen)

    // デバッグ用
    mediator_snapshot_sfen_set(sfen) {
      if (this.development_p) {
        // this.$buefy.toast.open({message: `mediator_snapshot_sfen -> ${sfen}`, queue: false})
      }
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_sfen に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうから
    edit_mode_snapshot_sfen_set(v) {
      if (this.sp_run_mode === "edit_mode") { // 操作モードでも呼ばれるから
        this.current_sfen = v
      }
    },

    // 棋譜コピー
    kifu_copy_handle(fomrat) {
      this.sound_play("click")
      this.general_kifu_copy(this.current_body, {to_format: fomrat})
    },

    // 局面URLコピー
    current_url_copy_handle() {
      this.sound_play("click")
      this.clipboard_copy({text: this.current_url})
    },

    // ツイートする
    // tweet_handle() {
    //   this.tweet_window_popup({url: this.current_url, text: this.tweet_hash_tag})
    // },

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
      if (params.format) {
        url = new URL(this.$config.MY_SITE_URL + `/share-board.${params.format}`)
      } else {
        url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      }

      // AbstractViewpointKeySelectModal から新しい abstract_viewpoint が渡されるので params で上書きすること
      params = {
        ...this.current_url_params,
        ...params,
      }

      _.each(params, (v, k) => {
        if (k !== "format") {
          if (v || true) {              // if (v) にしてしまうと turn = 0 のとき turn=0 が URL に含まれない
            url.searchParams.set(k, v)
          }
        }
      })

      return url.toString()
    },
  },

  computed: {
    current_url_params() {
      const params = {
        body:               this.current_body, // 編集モードでもURLを更新するため
        turn:               this.turn_offset,
        abstract_viewpoint: this.abstract_viewpoint,

      }
      return params
    },

    // URL
    current_url()                { return this.permalink_for()                                                                        },
    json_debug_url()             { return this.permalink_for({format: "json"})                                                        },

    // 外部アプリ
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        path: this.current_url,
        sfen: this.current_sfen,
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
        game_name: this.current_title,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.current_sfen,
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 最初に表示した手数より進めたか？
    advanced_p() { return this.turn_offset > this.config.record.initial_turn },

    // 常に画面上の盤面と一致している
    current_body() { return this.current_sfen || this.current_sfen },

    tweet_body() {
      let o = ""
      o += "\n"
      if (this.current_title) {
        o += "#" + this.current_title
      }
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
