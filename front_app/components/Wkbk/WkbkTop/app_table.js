import { BookIndexColumnInfo } from "../models/book_index_column_info.js"

export const app_table = {
  data() {
    return {
      // URLパラメータ
      page:        null,
      per:         null,
      tag:         null,
      // sort_column: null,
      // sort_order:  null,
      // scope:       null,

      // jsonで貰うもの
      books: null, // null:まだ読み込んでいない [...]:読み込んだ
      total: 0,

      // b-table で開いたIDたち
      detailed_keys: [],
    }
  },
  methods: {
    detail_set(enabled) {
      this.sound_play('click')
      if (enabled) {
        this.detailed_keys = this.books.map(e => e.key)
      } else {
        this.detailed_keys = []
      }
    },

    page_change_handle(page) {
      if (page <= 1) {
        page = null
      }
      this.router_push({page})
    },

    sort_handle(sort_column, sort_order) {
      this.sound_play("click")
      this.router_push({sort_column, sort_order})
    },
  },
  computed: {
    BookIndexColumnInfo()  { return BookIndexColumnInfo },

    url_params() {
      return {
        query:       this.query,
        page:        this.page,
        per:         this.per,
        tag:         this.tag,
        // scope:       this.scope,
        // sort_column: this.sort_column,
        // sort_order:  this.sort_order,
      }
    },
  },
}
