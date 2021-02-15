import dayjs from "dayjs"
import { AnswerKindInfo } from "../models/answer_kind_info.js"
import _ from "lodash"

export const app_journal = {
  data() {
    return {
      current_spent_sec: null,        // 現在の問題に切り替わってからの経過時間
    }
  },
  methods: {
    // 開発テスト用
    journal_test() {
      this.journal_init()
      this.current_index = 0
      if (this.current_xitem) {
        this.journal_next_init()
        this.journal_record("correct")
        this.current_index += 1
      }
      if (this.current_xitem) {
        this.journal_next_init()
        this.journal_record("mistake")
        this.current_index += 1
      }
      this.ox_stop()
    },

    // 最初に呼ぶ
    journal_init() {
      // this.book.xitems.forEach(xitem => {
      //   xitem.newest_answer_log = {
      //     answer_kind_key: null,
      //     spent_sec: null,
      //   }
      // })
    },

    // 次の問題の準備
    journal_next_init() {
      this.current_spent_sec = 0

      // this.current_xitem.newest_answer_log.spent_sec = 0
      // this.current_xitem.newest_answer_log.answer_kind_key = null
      // this.current_xitem.answer_stat.spent_sec_total = this.current_xitem.answer_stat.spent_sec_total || 0

      this.interval_counter.restart()
    },

    // 時間を進める
    journal_counter() {
      this.current_spent_sec += 1
    },

    // O or X を選択したとき
    journal_record(answer_kind_key) {
      this.interval_counter.stop()

      // 「はじめる」してからの経過時間を確定する
      this.total_sec += this.current_spent_sec

      // 直近のログ
      this.current_xitem.newest_answer_log.spent_sec = this.current_spent_sec
      this.current_xitem.newest_answer_log.answer_kind_key = answer_kind_key

      // 統計
      this.current_xitem.answer_stat[`${answer_kind_key}_count`] += 1
      this.current_xitem.answer_stat.spent_sec_total = (this.current_xitem.answer_stat.spent_sec_total || 0) + this.current_spent_sec

      this.journal_ox_create(answer_kind_key)
    },

    // O or X を記録
    journal_ox_create(answer_kind_key) {
      if (this.g_current_user) {
        const params = {
          article_id: this.current_article.id,
          answer_kind_key: answer_kind_key,
          book_id: this.book.id,
          spent_sec: this.current_spent_sec,
        }
        return this.$axios.$post("/api/wkbk/answer_logs/create.json", params).catch(e => {
          this.$nuxt.error(e.response.data)
          return
        }).then(e => {
          this.debug_alert(`ox_create ${e.id}`)
        })
      }
    },

    // b-table の時間
    table_spent_sec(xitem) {
      return this.table_time_format(xitem.newest_answer_log.spent_sec)
    },

    // b-table の総時間
    table_spent_sec_total(xitem) {
      return this.table_time_format(xitem.answer_stat.spent_sec_total)
    },

    table_time_format(v) {
      if (v != null) {
        let f = null
        if (v >= 60 * 60 * 24) {
          const h = Math.trunc(v / (60 * 60))
          return `${h}H`
        } else if (v >= 60 * 60) {
          f = "H:mm:ss"
        } else {
          f = "m:ss"
        }
        return dayjs.unix(v).format(f)
      }
    },

    // b-table の解答用
    journal_row_icon_attrs_for(xitem) {
      const answer_kind_info = this.journal_answer_kind_info_for(xitem)
      if (answer_kind_info) {
        return answer_kind_info.icon_attrs
      }
    },

    // article の answer_kind_info を返す
    journal_answer_kind_info_for(xitem) {
      const v = xitem.newest_answer_log.answer_kind_key
      if (v) {
        return AnswerKindInfo.fetch(v)
      }
    },
  },
  computed: {
    AnswerKindInfo() { return AnswerKindInfo },

    // 現在表示している問題の経過時間表記
    navbar_display_time() {
      this.table_time_format(this.current_spent_sec)
    },

    // 「不正解のみ残す」が動作するか？
    xitems_find_all_x_enabled() {
      return this.jo_counts.mistake >= 1 && (this.jo_counts.correct >= 1 || this.jo_counts.blank >= 1)
    },

    // 正解/不正解/空 の個数を返す
    // {correct: 1 mistake: 0, blank: 10} 形式
    jo_counts() {
      const a = this.AnswerKindInfo.values.reduce((a, e) => ({...a, [e.key]: 0}), {})
      a["blank"] = 0
      // a => {correct: 0, mistake: 0, blank: 0}
      this.book.xitems.forEach(xitem => {
        a[xitem.newest_answer_log.answer_kind_key || "blank"] += 1
      })
      return a
    },

    // クリア率
    jo_clear_rate() {
      if (this.max_count >= 1) {
        return this.float_to_perc2(this.jo_counts.correct / this.max_count)
      }
    },

    jo_ox_rate() {
      if (this.jo_ox_total) {
        return this.float_to_perc2(this.jo_counts.correct / this.jo_ox_total)
      }
    },

    jo_ox_total() {
      return this.jo_counts.correct + this.jo_counts.mistake
    },

    jo_total_sec() {
      return _.sumBy(this.xitems, e => e.newest_answer_log.spent_sec || 0)
    },

    jo_time_avg() {
      if (this.jo_ox_total === 0) {
        return "?"
      } else {
        const sec = this.jo_total_sec / this.jo_ox_total
        if (sec < 10) {
          return dayjs.unix(sec).format("s.SSS") + "秒"
        }
        if (sec < 60) {
          return dayjs.unix(sec).format("s") + "秒"
        }
        return dayjs.unix(sec).format("m分s秒")
      }
    },

    jo_summary() {
      let out = ""
      out += `達成率 ${this.jo_clear_rate}% (${this.jo_counts.correct}/${this.max_count})\n`
      out += `正解率 ${this.jo_ox_rate} (${this.jo_counts.correct}/${this.jo_ox_total})\n`
      out += `平均 ${this.jo_time_avg}\n`
      out += `正解 ${this.jo_counts.correct}\n`
      out += `不正解 ${this.jo_counts.mistake}\n`
      out += `未解答 ${this.jo_counts.blank}\n`
      return out
    },
  },
}
