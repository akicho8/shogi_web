import { Article } from "../models/article.js"

export const app_article = {
  data() {
    return {
      article: null,
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    edit_mode_snapshot_sfen(sfen) {
      if (this.article.init_sfen !== sfen) {
        if (this.article.moves_answers.length >= 1) {
          this.toast_ok("元の配置を変更したので正解を削除しました")
        }
        this.article_init_sfen_set(sfen)
      }
    },

    article_init_sfen_set(sfen) {
      this.answers_clear()
      this.article.init_sfen = sfen
      this.valid_count = 0
    },

    current_moves() {
      return this.$refs.WkbkArticleEditAnswer.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    ////////////////////////////////////////////////////////////////////////////////

    article_save_handle() {
      this.sound_play("click")

      if (this.sns_login_required()) {
        return true
      }

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return true
      }

      if (this.WkbkConfig.value_of("moves_answers_empty_validate_p")) {
        if (this.article.moves_answers.length === 0) {
          this.toast_warn("正解が未登録です")
          return true
        }
      }

      if (!this.article.title) {
        this.toast_warn("なんかしらのタイトルを捻り出してください")
        return true
      }

      if (this.WkbkConfig.value_of("valid_requied")) {
        if (this.article.moves_answers.length >= 1) {
          if (this.article.new_record_p) {
            if (this.valid_count === 0) {
              this.toast_warn("検証してください")
              return true
            }
          }
        }
      }

      const new_record_p = this.article.new_record_p
      const before_save_button_name = this.save_button_name

      return this.$axios.$post("/api/wkbk/articles/save.json", {article: this.article}).then(e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.article) {
          this.article = new Article(e.article)
          this.talk_stop()
          this.toast_ok(`${before_save_button_name}しました`)

          // 新規の初期値にするため保存しておく
          if (new_record_p) {
            this.default_book_keys   = this.article.book_keys
            this.default_lineage_key = this.article.lineage_key
            this.default_folder_key = this.article.folder_key
          }

          // this.$router.push({name: "rack-articles", query: {scope: this.article.redirect_scope_after_save}})
          this.$router.push({name: "rack-articles"})
        }
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.article.moves_answers.length === 0) {
        if (this.exam_run_count === 0) {
          this.toast_warn("先に正解を作ってください")
        }
      }
      if (this.article.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
        this.valid_count += 1
      }
      this.exam_run_count += 1
    },

    turn_offset_set(v) {
      this.answer_base_turn_offset = v
    },
  },

  computed: {
    save_button_name()    { return this.article.new_record_p ? "保存" : "更新" },
    save_button_enabled() { return this.article.moves_answers.length >= 1      },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    owner_p()    { return this.article.owner_p(this.g_current_user) },
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },
  },
}
