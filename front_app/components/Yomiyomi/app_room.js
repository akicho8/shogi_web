import _ from "lodash"

export const app_room = {
  data() {
    return {
      room_code: "",                           // リアルタイム共有合言葉
      user_code: this.config.record.user_code, // 自分と他者を区別するためのコード
    }
  },
  mounted() {
    this.room_code_set(this.config.record.room_code, {initial: true})
  },
  methods: {
    room_code_set(room_code, options = {}) {
      options = {
        initial: false,
        ...options,
      }

      room_code = _.trim(room_code)
      const changed_p = this.room_code != room_code
      this.room_code = room_code

      if (changed_p) {
        if (!options.initial) {
          if (this.room_code) {
            this.toast_ok(`合言葉を「${this.room_code}」に設定しました`)
          } else {
            this.toast_ok("合言葉を削除しました")
          }
        }
      }

      this.room_unsubscribe() // 内容が変更になったかもしれないのでいったん解除
      if (this.room_code) {
        this.room_setup(options)
      }
    },

    room_setup(options = {}) {
      this.room_unsubscribe()
      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "Yomiyomi::RoomChannel", room_code: this.room_code}, {
        connected: () => {
          this.idol_timer_start()
          this.board_info_request()
        },
        disconnected: () => {
          if (this.development_p) {
            this.toast_ok("部屋を解放しました")
          }
        },
      })
    },

    room_unsubscribe() {
      this.ac_unsubscribe("$ac_room")
    },

    ac_room_perform(action, params = {}) {
      params = Object.assign({}, {
        user_code: this.user_code,
      }, params)

      if (this.$ac_room) {
        this.$ac_room.perform(action, params) // --> app/channels/yomiyomi/room_channel.rb
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_share(sfen) {
      this.ac_room_perform("sfen_share", {
        sfen: sfen,
        title: this.current_title,
      }) // --> app/channels/yomiyomi/room_channel.rb
    },
    sfen_share_broadcasted(params) {
      if (params.user_code === this.user_code) {
        // 自分から自分へ
      } else {
        this.attributes_set(params)
      }
    },
    ////////////////////////////////////////////////////////////////////////////////
    title_share(share_sfen) {
      this.ac_room_perform("title_share", {
        title: this.current_title,
      }) // --> app/channels/yomiyomi/room_channel.rb
    },
    title_share_broadcasted(params) {
      if (params.user_code === this.user_code) {
        // 自分から自分へ
      } else {
        this.attributes_set(params)
        this.toast_ok(`タイトルを${params.title}に変更しました`)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    attributes_set(params) {
      if (params.title) {
        this.current_title = params.title
      }
      if (params.sfen) {
        this.current_sfen = params.sfen
        this.turn_offset = this.sfen_parse(params.sfen).moves.length
      }
    },
  },
}
