import AbstractViewpointKeySelectModal from "./AbstractViewpointKeySelectModal.vue"
import TweetModal from "./TweetModal.vue"

export const app_chore = {
  methods: {
    // 視点設定変更
    abstract_viewpoint_setting_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: AbstractViewpointKeySelectModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: {
          abstract_viewpoint: this.abstract_viewpoint,
          permalink_for: this.permalink_for,
        },
        onCancel: () => this.sound_play("click"),
        events: {
          "update:abstract_viewpoint": v => {
            this.abstract_viewpoint = v
          }
        },
      })
    },

    // ツイート
    tweet_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: TweetModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: { base: this.base },
        onCancel: () => this.sound_play("click"),
      })
    },

    // タイトル編集
    title_edit() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.current_title_set(value)
        },
      })
    },

    // ツイートする
    // tweet_handle() {
    //   this.tweet_window_popup({url: this.current_url, text: this.tweet_hash_tag})
    // },

    tweet_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body})
    },

    exit_handle() {
      this.sound_play("click")
      if (this.ac_room || this.chess_clock) {

        const message = "対局中のように思われますが本当に退室しますか？"
        this.talk(message)

        this.$buefy.dialog.confirm({
          message: message,
          cancelText: "キャンセル",
          confirmText: "退室する",
          focusOn: "cancel",
          onCancel: () => {
            this.talk_stop()
            this.sound_play("click")
          },
          onConfirm: () => {
            this.talk_stop()
            this.sound_play("click")
            this.$router.push({name: "index"})
          },
        })
      } else {
        this.$router.push({name: "index"})
      }
    },
  },
}
