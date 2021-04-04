import _ from "lodash"

export const app_kifu_copy_buttons = {
  data() {
    return {
      // answer_base_sfen: null, // 正解作成元の盤面のSFEN
    }
  },

  methods: {
    // 指定の解答の「ぴよ将棋」へのリンク
    answers_piyo_shogi_app_with_params_url(moves_answer) {
      return this.piyo_shogi_auto_url({
        turn: 0,
        sfen: this.article.init_sfen_with(moves_answer),
        viewpoint: this.base.article.viewpoint,
      })
    },

    // 指定の解答の「KENTO」へのリンク
    answers_kento_app_with_params_url(moves_answer) {
      return this.kento_full_url({
        turn: 0,
        sfen: this.article.init_sfen_with(moves_answer),
        viewpoint: this.base.article.viewpoint,
      })
    },

    // 指定の解答のコピー処理
    answers_kifu_copy_handle(moves_answer) {
      this.sound_play("click")
      this.general_kifu_copy(this.article.init_sfen_with(moves_answer), {to_format: "kif"})
    },

    // ////////////////////////////////////////////////////////////////////////////////
    //
    // // 解答元の指し手の長いSFENを同期取得
    // answer_base_play_mode_advanced_full_moves_sfen_set(sfen) {
    //   this.answer_base_sfen = sfen
    // },
    //
    // // 解答元の指し手のコピー処理
    // answer_base_kifu_copy_handle() {
    //   this.sound_play("click")
    //   this.general_kifu_copy(this.answer_base_sfen, {to_format: "kif"})
    // },
  },

  computed: {
    // // 解答元の指し手の「ぴよ将棋」へのリンク
    // answer_base_piyo_shogi_app_with_params_url() {
    //   return this.piyo_shogi_auto_url({
    //     turn: 0,
    //     sfen: this.answer_base_sfen,
    //     viewpoint: this.base.article.viewpoint,
    //   })
    // },
    // // 解答元の指し手の「KENTO」へのリンク
    // answer_base_kento_app_with_params_url() {
    //   return this.kento_full_url({
    //     turn: 0,
    //     sfen: this.answer_base_sfen,
    //     viewpoint: this.base.article.viewpoint,
    //   })
    // },
  },
}
