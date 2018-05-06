import _ from "lodash"
import { PresetInfo } from 'shogi-player/src/preset_info.js'

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/lobby_channel.rb
  App.lobby = App.cable.subscriptions.create("LobbyChannel", {
    connected: function() {
      // App.lobby_vm.puts("connected")
      // this.install()
      // this.appear()
      // this.perform("appear")
    },
    // Called when the WebSocket connection is closed
    disconnected: function() {
      // App.lobby_vm.puts("disconnected")
      // this.uninstall()
    },
    // Called when the subscription is rejected by the server
    rejected: function() {
      // App.lobby_vm.puts("rejected")
      // this.uninstall()
    },

    received: function(data) {
      // App.lobby_vm.chat_rooms = []
      // App.lobby_vm.chat_rooms = [data["chat_room"]]
      // App.lobby_vm.puts(data)
      if (data["chat_room_created"]) {
        App.lobby_vm.chat_rooms = _.concat([data["chat_room_created"]], App.lobby_vm.chat_rooms)
      }
      if (data["chat_rooms"]) {
        App.lobby_vm.chat_rooms = data["chat_rooms"]
      }
      if (data["online_users"]) {
        App.lobby_vm.online_users = data["online_users"]
      }
      if (data["matching_wait"]) {
        App.lobby_vm.matching_wait()
      }
    },

    matching_start(data) {
      this.perform("matching_start", data)
    },
    matching_cancel(data) {
      this.perform("matching_cancel", data)
    },
  })

  App.lobby_vm = new Vue({
    el: "#lobby_app",
    // components: { "messenger": messenger },
    data: function() {
      return {
        // status_list: [],
        chat_rooms: [],
        online_users: [],                // 参加者
        columns: [
          { field: 'name', label: '部屋', },
        ],
        matching_start_p: !_.isNil(js_global_params.current_chat_user.matching_at),
        setting_modal_p: false,
        current_lifetime_key: "lifetime5_min",

        ps_preset_key: js_global_params.current_chat_user["ps_preset_key"],
        po_preset_key: js_global_params.current_chat_user["po_preset_key"],
        current_hira_or_koma: null,
      }
    },

    created() {
      this.current_hira_or_koma = this.hira_or_koma
    },

    watch: {
      current_hira_or_koma(v) {
        if (v === "hirate") {
          this.ps_preset_key = "平手"
          this.po_preset_key = "平手"
        }
      },
      ps_preset_key(v) {
        if (v !== "平手") {
          this.po_preset_key = "平手"
        }
      },
      po_preset_key(v) {
        if (v !== "平手") {
          this.ps_preset_key = "平手"
        }
      },
    },
    current_preset_info2() {
      return PresetInfo.fetch(this.po_preset_key)
    },

    methods: {
      // puts(v) {
      //   this.status_list.push(v)
      // },
      chat_user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      matching_setting_open() {
        if (this.matching_start_p) {
          this.matching_start_p = false
          App.lobby.matching_cancel()
        } else {
          this.setting_modal_p = true
        }
        // this.setting_modal_p = true
        // this.$nextTick(() => this.$refs.message_input.focus())
        // if (this.matching_start_p) {
        //   this.matching_start_p = false
        //   App.lobby.matching_cancel()
        // } else {
        //   this.matching_start_p = true
        //   App.lobby.matching_start()
        // }
      },

      matching_start() {
        this.setting_modal_p = false
        App.lobby.matching_start({
          ps_preset_key: this.current_preset_info1.key,
          po_preset_key: this.current_preset_info2.key,
          lifetime_key: this.current_lifetime_key,
        })
      },

      matching_wait() {
        this.matching_start_p = true
      },

      // // 手合割の変更
      // preset_key_update(v) {
      //   if (this.ps_preset_key !== v) {
      //     this.ps_preset_key = v
      //     App.chat_room.preset_key_update({ps_preset_key: this.current_preset_info1.name})
      //     App.chat_room.system_say(`手合割を${this.current_preset_info1.name}に変更しました`)
      //   }
      // },

      // modal_open() {
      // },
      // message_enter() {
      //   if (this.message !== "") {
      //     if (this.message_to) {
      //       App.single_notification.message_send_to({from: js_global_params.current_chat_user, to: this.message_to, message: this.message})
      //     } else {
      //       App.system_notification.message_send_all({from: js_global_params.current_chat_user, message: this.message})
      //     }
      //     // Vue.prototype.$toast.open({message: "送信完了", position: "is-top", type: "is-info", duration: 1000})
      //   }
      //   this.message = ""
      // },

    },
    computed: {
      // // 持ち時間の変更
      // lifetime_key_update(v) {
      //   // if (this.current_lifetime_key !== v) {
      //   //   this.current_lifetime_key = v
      //   //   App.chat_room.lifetime_key_update({lifetime_key: this.current_lifetime_info.key})
      //   //   App.chat_room.system_say(`持ち時間を${this.current_lifetime_info.name}に変更しました`)
      //   // }
      // },

      // 持ち時間項目一覧
      lifetime_infos() {
        return lobby_app_params.lifetime_infos
      },

      // 選択中の持ち時間項目
      current_lifetime_info() {
        return _.find(this.lifetime_infos, (e) => e.key === this.current_lifetime_key)
      },

      // 手合割一覧
      preset_infos() {
        // return PresetInfo.values
        return lobby_app_params.preset_infos
      },

      // 現在選択されている手合割情報
      current_preset_info1() {
        return PresetInfo.fetch(this.ps_preset_key)
      },
      current_preset_info2() {
        return PresetInfo.fetch(this.po_preset_key)
      },

      // latest_status_list() {
      //   return _.takeRight(this.status_list, 10)
      // },
      matching_class() {
        if (this.matching_start_p) {
          return ["is-danger"]
        } else {
          return ["is-primary"]
        }
      },

      matching_label() {
        if (this.matching_start_p) {
          return "マッチング中"
        } else {
          return "ゲーム開始"
        }
      },

      hira_or_koma() {
        if (this.ps_preset_key === "平手" && this.po_preset_key === "平手") {
          return "hirate"
        } else {
          return "komaochi"
        }
      },

      hirate_komaochi_infos() {
        return {
          hirate:   {name: "平手",   },
          komaochi: {name: "駒落ち", },
        }
      },

    },
  })
})
