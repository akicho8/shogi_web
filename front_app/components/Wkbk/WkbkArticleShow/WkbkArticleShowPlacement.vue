<template lang="pug">
MainSection.WkbkArticleShowPlacement
  .container
    .columns.is-centered
      .column
        .CustomShogiPlayerWrap
          CustomShogiPlayer(
            sp_mobile_vertical="is_mobile_vertical_off"
            sp_run_mode="edit_mode"
            :sp_body="base.article.init_sfen"
            :sp_turn="0"
            :sp_viewpoint.sync="base.viewpoint"
            :sp_sound_body_changed="false"
            :sp_sound_enabled="false"
            sp_slider="is_slider_on"
            sp_controller="is_controller_on"
            @update:edit_mode_snapshot_sfen="base.edit_mode_snapshot_sfen"
            ref="main_sp"
            )
          .footer_buttons
            .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
              b-button(@click="king_formation_auto_set(true)") 詰将棋検討用玉配置
              b-button(@click="king_formation_auto_set(false)") 玉回収

            .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
              PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
              KentoButton(tag="a" :href="kento_app_with_params_url" target="_blank")
              KifCopyButton(@click="kifu_copy_handle") コピー

            //- .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
            //-   b-button(@click="base.any_source_read_handle") 棋譜の読み込み
            //-
            //- .buttons.mb-0.has-addons.is-centered.are-small.mt-3(v-if="development_p")
            //-   b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(3)") 3
            //-   b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(4)") 4
            //-   b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(5)") 5
            //-   b-button(@click="$refs.main_sp.sp_object().mediator.shuffle_apply(6)") 6
            //-   .ml-1
            //-   b-button(icon-left="arrow-left"  @click="$refs.main_sp.sp_object().mediator.slide_xy(-1, 0)")
            //-   b-button(icon-left="arrow-down"  @click="$refs.main_sp.sp_object().mediator.slide_xy(0, 1)")
            //-   b-button(icon-left="arrow-up"    @click="$refs.main_sp.sp_object().mediator.slide_xy(0, -1)")
            //-   b-button(icon-left="arrow-right" @click="$refs.main_sp.sp_object().mediator.slide_xy(1, 0)")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowPlacement",
  mixins: [
    support_child,
  ],

  created() {
    this.base.sp_body      = this.base.article.init_sfen
    this.base.sp_viewpoint = this.base.viewpoint
  },

  mounted() {
    this.base.piece_box_piece_counts_adjust()
  },

  methods: {
    // 玉配置/玉回収
    king_formation_auto_set(v) {
      this.sound_play("click")
      if (this.$refs.main_sp.sp_object().mediator.king_formation_auto_set_on_off(v)) {
        this.base.piece_box_piece_counts_adjust() // 玉が増える場合があるので駒箱を調整する
      } else {
        if (v) {
          this.toast_warn("配置する場所がありません")
        } else {
          this.toast_warn("回収するブロックがありません")
        }
      }
    },
    // 棋譜コピー
    kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.base.sp_body, {to_format: "kif"})
    },
  },

  computed: {
    // ぴよ将棋で開く
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        turn: 0,
        sfen: this.base.sp_body,
        viewpoint: this.base.viewpoint,
      })
    },
    // KENTOで開く
    kento_app_with_params_url() {
      return this.kento_full_url({
        turn: 0,
        sfen: this.base.sp_body,
        viewpoint: this.base.viewpoint,
      })
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleShowPlacement
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .CustomShogiPlayerWrap
      border: 1px dashed change_color($danger, $alpha: 0.5)

.MainSection.section.WkbkArticleShowPlacement
  padding: 0

  .column
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    .CustomShogiPlayerWrap
      +mobile
        margin: 0.75rem 0
      +tablet
        margin: $wkbk_share_gap 0

      width: 100%
      +tablet
        max-width: 54vmin
      .footer_buttons
        .button
          margin-bottom: 0
</style>
