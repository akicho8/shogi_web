export default {
  data() {
    return {
      query: null,
    }
  },

  methods: {
    // 送信ボタンを押した
    search_click_handle() {
      this.debug_alert(`click: ${this.query}`)
      if (this.query === "") {
        this.debug_alert("query is blank")
        return
      }
      this.update_search({query: this.query})
    },

    // Enterキーを叩いた
    search_enter_handle() {
      this.debug_alert("enter")
      this.search_click_handle()
    },

    // 候補から選択した or 選択が外れた(このときはnullがくる)
    //  選択した瞬間は、まだ v-model に変化がないため this.query を参照しても何も入ってない
    //  そのかわり引数で選択したものが送られてくるのでそれを使う
    search_select_handle(query) {
      this.debug_alert(`select: ${query}`)
      if (query) {
        this.update_search({query: query})
      }
    },
  },
}
