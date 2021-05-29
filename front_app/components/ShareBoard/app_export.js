export const app_export = {
  methods: {
    // 現在のURLをコピー
    current_url_copy_handle() {
      this.sound_play("click")
      this.clipboard_copy({text: this.current_url})
    },

    // 指定の棋譜をコピー
    kifu_copy_handle(e) {
      this.sound_play("click")
      this.general_kifu_copy(this.current_body, {to_format: e.format_key, turn: this.turn_offset})
    },

    //////////////////////////////////////////////////////////////////////////////// show

    kifu_show_url(e) {
      return this.permalink_for({
        format: e.format_key,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方が優先される
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      if (typeof window !== 'undefined') {
        // window.location.href = this.kifu_show_url(e)
        this.window_popup(this.kifu_show_url(e))
      }
    },

    //////////////////////////////////////////////////////////////////////////////// download

    kifu_download_url(e) {
      return this.permalink_for({
        format: e.format_key,
        body_encode: e.body_encode,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方が優先される
        disposition: "attachment",
      })
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        window.location.href = this.kifu_download_url(e)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 棋譜だけを含むURLのコピー
    url_without_room_code_copy_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.clipboard_copy({text: this.url_without_room_code})
    },
  },
  computed: {
    // 棋譜だけを含むURL
    url_without_room_code() {
      const e = {...this.current_url_params}
      if (this.present_p(e.room_code)) {
        delete e.room_code
      }
      return this.permalink_from_params(e)
    },
  },
}
