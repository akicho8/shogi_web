import { ArticleShowTabInfo } from '../models/article_show_tab_info.js'

export const app_tabs = {
  data() {
    return {
      tab_index: null,
    }
  },

  methods: {
    tab_set(tab_key) {
      this.tab_index = this.ArticleShowTabInfo.fetch(tab_key).code
    },

    show_tab_change_handle(v) {
      this.sound_play("click")
      if (false) {
        this.talk(this.current_tab_info.name)
      }
      this[`${this.current_tab_info.key}_tab_handle`]()
    },

    //////////////////////////////////////////////////////////////////////////////// 各タブ切り替えた直後の初期化処理

    placement_tab_handle() {
      this.tab_set("placement")
    },

    answer_tab_handle() {
      this.tab_set("answer")
    },

    form_tab_handle() {
      this.tab_set("form")
    },

    validation_tab_handle() {
      this.tab_set("validation")
      this.exam_run_count = 0
      this.talk(this.article.direction_message)
    },
  },
  computed: {
    ArticleShowTabInfo() { return ArticleShowTabInfo                       },
    current_tab_info()   { return ArticleShowTabInfo.fetch(this.tab_index) },
  },
}
