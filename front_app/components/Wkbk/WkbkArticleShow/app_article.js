import { Article } from "../models/article.js"

export const app_article = {
  data() {
    return {
      article: null,
    }
  },

  methods: {
    current_moves() {
      return this.$refs.WkbkArticleShowAnswer.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    ////////////////////////////////////////////////////////////////////////////////

    play_mode_advanced_moves_set(moves) {
      // if (this.article.moves_answers.length === 0) {
      //   if (this.exam_run_count === 0) {
      //     this.toast_warn("先に正解を作ってください")
      //   }
      // }
      if (this.article.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
        // this.valid_count += 1
      }
      // this.exam_run_count += 1
    },

    // turn_offset_set(v) {
    //   // this.answer_turn_offset = v
    // },
  },

  computed: {
    // save_button_name()    { return this.article.new_record_p ? "保存" : "更新" },
    // save_button_enabled() { return this.article.moves_answers.length >= 1      },

    owner_p() {
      if (this.article) {
        return this.g_current_user && this.g_current_user.id === this.article.user.id
      }
    },
  },
}
