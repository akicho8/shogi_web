import _ from "lodash"
import dayjs from "dayjs"

const DESTROY_AFTER_WAIT = 3.0

export const app_room = {
  data() {
    return {
      room_code: this.config.record.room_code, // リアルタイム共有合言葉
      user_code: this.config.record.user_code, // 自分と他者を区別するためのコード(タブが2つあればそれぞれ異なる)
      room_creating_busy: 0,                   // 1以上なら接続を試みている最中
      ac_room: null,
    }
  },
  mounted() {
    this.ls_setup() // user_name の復帰

    if (this.$route.query.force_user_name) {
      this.user_name = this.$route.query.force_user_name
    }

    if (this.room_code) {
      if (this.user_name) {
        // 合言葉設定済みURLから来て名前は設定しているのですぐに共有する
        this.room_create()
      } else {
        // 合言葉設定済みURLから来て名前は設定していない
        this.toast_ok("ハンドルネームを入力してください")
        this.room_code_modal_handle()
      }
    } else {
      // 通常の起動
      if (this.development_p) {
        // this.room_code_set("__room_code__", "alice")
      }
    }

  },
  beforeDestroy() {
    if (this.ac_room) {
      this.toast_ok("共有を解除して退室しました")
    }
    this.room_destroy()
  },
  methods: {
    room_code_set(room_code, user_name) {
      let apply = false

      room_code = _.trim(room_code)
      if (this.room_code === room_code) {
        if (this.ac_room) {
          this.toast_ok("すでに共有しています")
        } else {
          this.debug_alert("URL経由で飛んできてハンドルネームを入力した直後に接続する")
          apply = true
        }
      } else {
        this.room_code = room_code
        apply = true
        if (this.room_code) {
          this.toast_ok("合言葉を設定しました")
        } else {
          this.toast_ok("合言葉を削除して退室しました")
        }
      }

      user_name = _.trim(user_name)
      if (this.user_name != user_name) {
        this.user_name = user_name
        if (this.ac_room) {
          this.toast_ok("ニックネームの変更を共有しました")
          this.member_bc_interval_runner.restart()
        }
      }

      if (apply) {
        if (this.room_code) {
          this.room_recreate()
        } else {
          this.room_destroy()
        }
      }
    },

    // ac_room.unsubscribe() をした直後に subscribe すると subscribe が無効になる
    // なので少し待ってから実行する
    room_recreate() {
      if (this.room_creating_busy >= 1) {
        this.toast_ng("共有作業中です")
        return
      }
      if (this.ac_room) {
        this.room_destroy()
        this.room_creating_busy += 1
        const loading = this.$buefy.loading.open()
        this.delay_block(DESTROY_AFTER_WAIT, () => {
          this.room_create()
          this.room_creating_busy = 0
          loading.close()
        })
      } else {
        this.room_create()
      }
    },

    room_recreate_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.room_recreate()
    },

    room_create() {
      this.debug_alert("room_create")
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.room_code, "this.room_code")

      this.member_infos_clear()
      // this.room_destroy()
      this.__assert__(this.ac_room == null, "this.ac_room == null")
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        connected: () => {
          this.revision_increment_timer.restart()
          this.setup_info_request()
          this.member_bc_interval_runner.restart()
        },
        disconnected: () => {
        },
      })
    },

    room_destroy() {
      this.debug_alert("room_destroy")
      this.ac_unsubscribe("ac_room")
    },

    // perform のラッパーで共通のパラメータを入れる
    ac_room_perform(action, params = {}) {
      params = Object.assign({}, {
        from_user_code: this.user_code, // 送信者識別子
        from_user_name: this.user_name, // 送信者名
        performed_at: dayjs().unix(),   // 実行日時
        revision: this.$revision,       // 盤リビジョン(高い方が信憑性のある情報)
      }, params)

      if (this.ac_room) {
        this.ac_room.perform(action, params) // --> app/channels/share_board/room_channel.rb
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    title_share(share_sfen) {
      this.ac_room_perform("title_share", {
        title: this.current_title,
      }) // --> app/channels/share_board/room_channel.rb
    },
    title_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        this.setup_by_params(params)
      }
      this.toast_ok(`${this.user_call_name(params.from_user_name)}がタイトルを${params.title}に変更しました`)
    },

    ////////////////////////////////////////////////////////////////////////////////
    setup_by_params(params) {
      if ("title" in params) {
        this.current_title = params.title
      }
      if ("sfen" in params) {
        this.current_sfen = params.sfen
        this.turn_offset = params.turn_offset
      }
      if ("order_func_p" in params) {
        this.om_vars_copy_from(params)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    room_code_url_copy_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      if (!this.room_code) {
        this.toast_warn("まだ合言葉を設定してません")
        return
      }
      this.clipboard_copy({text: this.share_board_with_room_code_url})
    },

    ////////////////////////////////////////////////////////////////////////////////
    fake_error() {
      this.ac_room_perform("fake_error", {
        value: null,
      }) // --> app/channels/share_board/room_channel.rb
    },
    fake_error_broadcasted(params) {
    },
  },
  computed: {
    room_code_valid_p() { return this.room_code != "" },             // 合言葉があるか？
    connectable_p()     { return this.room_code && this.user_name }, // 合言葉と名前が入力済みなので共有可能か？

    ////////////////////////////////////////////////////////////////////////////////
    current_sfen_attrs() {
      return {
        sfen:              this.current_sfen,
        turn_offset:       this.current_sfen_info.turn_offset_max, // これを入れない方が早い？
        last_location_key: this.current_sfen_info.last_location.key,
      }
    },
    current_sfen_info() {
      return this.sfen_parse(this.current_sfen)
    },
    current_sfen_turn_offset() {
      return this.current_sfen_info.turn_offset_max
    },
    ////////////////////////////////////////////////////////////////////////////////

    // 合言葉だけを付与したURL
    share_board_with_room_code_url() {
      const url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      if (this.room_code) {
        url.searchParams.set("room_code", this.room_code)
      }
      return url.toString()
    },

  },
}
