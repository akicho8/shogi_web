<template lang="pug">
.Xclock(:class="clock_box.running_p ? 'is_xclock_active' : 'is_xclock_inactive'")
  DebugBox(v-if="development_p")
    div turn: {{clock_box.turn}}
    div running_p: {{clock_box.running_p}}
    div timer: {{clock_box.timer}}
    div counter: {{clock_box.counter}}
    div zero_arrival: {{clock_box.zero_arrival}}
    div mouse_cursor_p: {{mouse_cursor_p}}

  //////////////////////////////////////////////////////////////////////////////// form
  template(v-if="!clock_box.running_p")
    .screen_container.is-flex
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in clock_box.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="xswitch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.bar_class" v-if="e.active_p")
            .inactive_current_bar(v-else)
            .wide_container.form.is-flex
              b-field(label="持ち時間(分)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.main_minute_for_vmodel" :min="0" :max="60*9" :exponential="true" @pointerdown.native.stop="" :checkHtml5Validity="false")
              b-field(label="1手ごとに加算(秒)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.every_plus" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="秒読み" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_read_sec_for_v_model" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="猶予(秒)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_extra_sec" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
      XclockAppFooter(:base="base" ref="XclockAppFooter")

  //////////////////////////////////////////////////////////////////////////////// 実行中
  template(v-if="clock_box.running_p")
    .pause_bg(v-if="!clock_box.timer")
    .screen_container.is-flex(:class="{mouse_cursor_hidden_p: mouse_cursor_hidden_p}")
      b-icon.controll_button.pause.is-clickable(icon="pause" v-if="clock_box.timer" @click.native="pause_handle")
      b-icon.controll_button.resume.is-clickable(icon="play" v-if="!clock_box.timer" @click.native="resume_handle")
      b-icon.controll_button.stop.is-clickable(icon="stop" v-if="!clock_box.timer" @click.native="stop_handle")
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in clock_box.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="xswitch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.bar_class" v-if="e.active_p && clock_box.timer")
            .inactive_current_bar(v-else)
            .wide_container.time_fields.is-flex(:class="[`display_lines-${e.display_lines}`, `text_width-${e.to_time_format.length}`]")
              .field(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1")
                .time_label 残り時間
                .time_value.fixed_font.is_line_break_off
                  | {{e.to_time_format}}
              .field(v-if="e.initial_read_sec >= 1")
                .time_label 秒読み
                .time_value.fixed_font.is_line_break_off
                  | {{e.read_sec}}
              .field(v-if="e.initial_extra_sec >= 1")
                .time_label 猶予
                .time_value.fixed_font.is_line_break_off
                  | {{e.extra_sec}}

  //////////////////////////////////////////////////////////////////////////////// form
  .debug_container.mt-5(v-if="development_p")
    ClockBoxInspector(:clock_box="clock_box" v-if="clock_box")
    .box
      p mouse_cursor_p: {{mouse_cursor_p}}

</template>

<script>
import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { DeviseAngle  } from "@/components/models/devise_angle.js"
import { isMobile     } from "@/components/models/is_mobile.js"
import { FullScreenController   } from "@/components/models/full_screen_controller.js"
import { CcRuleInfo       } from "@/components/models/cc_rule_info.js"

import { support      } from "./support.js"

import { mouse_cursor_hidden_mixin         } from "../models/mouse_cursor_hidden_mixin.js"
import { mobile_screen_adjust_mixin } from "../models/mobile_screen_adjust_mixin.js"
import { app_keyboard_shortcut    } from "./app_keyboard_shortcut.js"

export default {
  name: "XclockApp",
  mixins: [
    support,
    mouse_cursor_hidden_mixin,
    app_keyboard_shortcut,
    mobile_screen_adjust_mixin,
  ],
  data() {
    return {
      clock_box: null,
      full_screen: null,
    }
  },
  created() {
    this.clock_box = new ClockBox({
      turn: 0,
      clock_switch_hook: () => {
        this.sound_play("click")
      },
      time_zero_callback: e => {
        this.sound_play("lose")
        this.say("時間切れ")
        this.$buefy.dialog.alert({
          message: "時間切れ",
          onConfirm: () => { this.stop_handle() },
        })
      },
      second_decriment_hook: (single_clock, key, t, m, s) => {
        if (1 <= m && m <= 10) {
          if (s === 0) {
            this.say(`${m}分`)
          }
        }
        if (t === 10 || t === 20 || t === 30) {
          this.say(`${t}秒`)
        }
        if (t <= 5) {
          this.say(`${t}`)
        }
        if (t <= 6 && false) {
          const index = single_clock.index
          setTimeout(() => {
            if (index === single_clock.base.current_index) {
              this.say(`${t - 1}`)
            }
          }, 1000 * 0.75)
        }
      },
    })

    // 初期値
    this.rule_set({initial_main_min: 5, initial_read_sec:0, initial_extra_sec: 0, every_plus: 5})

    if (this.development_p) {
      this.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 7文字
      this.rule_set({initial_main_min: 30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 5文字
      this.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0}) // 2行 7文字
      this.rule_set({initial_main_min: 60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60}) // 3行 7文字
    }
  },
  mounted() {
    this.ga_click("対局時計")
    if (this.development_p) {
    } else {
      // this.$refs.XclockAppFooter.$refs.preset_menu_pull_down.toggle()
    }
    this.full_screen = new FullScreenController()
  },
  beforeDestroy() {
    this.full_screen.off()
    this.clock_box.timer_stop()
  },
  methods: {
    resume_handle() {
      this.sound_play("click")
      this.clock_box.resume_handle()
      this.sound_stop_all()
    },
    pause_handle() {
      if (this.clock_box.running_p) {
        this.sound_stop_all()
        this.sound_play("click")
        this.clock_box.pause_handle()

        if (false) {
          this.$buefy.dialog.confirm({
            title: "ポーズ中",
            message: `終了しますか？`,
            confirmText: "終了",
            cancelText: "再開",
            type: "is-danger",
            hasIcon: false,
            trapFocus: true,
            focusOn: "cancel",
            onCancel:  () => this.resume_handle(),
            onConfirm: () => this.stop_handle(),
          })
        }
      }
    },
    stop_handle() {
      if (this.clock_box.running_p) {
        this.full_screen.off()
        this.sound_stop_all()
        this.sound_play("click")
        this.clock_box.stop_handle()
      }
    },
    play_handle() {
      if (this.clock_box.running_p) {
      } else {
        this.full_screen.on()
        this.sound_play("start")
        this.ga_click("対局時計●")
        this.say(this.play_talk_message())
        this.clock_box.play_handle()
      }
    },
    play_talk_message() {
      let s = ""
      s += "対局かいし。"
      if (isMobile.any()) {
        if (DeviseAngle.portrait_p()) {
          s += "ブラウザのタブを1つだけにして、スマホを横向きにしてください"
        } else {
          s += "ブラウザのタブを1つだけにして、スマホをいったん縦持ちにしてから横持ちにすると、全画面になるはずです"
        }
      } else {
        s += "キーボードの左右のシフトキーとかで、てばんを変更できます"
      }
      return s
    },
    xswitch_handle(e) {
      // 開始前の状態では条件なく手番を切り替える
      if (!this.clock_box.running_p) {
        this.clock_box.clock_switch()
        return
      }

      e.tap_on()
    },
    copy_handle() {
      this.sound_play("click")
      this.say("左の設定を右にコピーしますか？")

      this.$buefy.dialog.confirm({
        title: "コピー",
        message: `左の設定を右にコピーしますか？`,
        confirmText: "コピーする",
        cancelText: "キャンセル",
        // type: "is-danger",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => {
          this.sound_stop_all()
          this.sound_play("click")
          this.clock_box.copy_1p_to_2p()
          this.say("コピーしました")
        },
        onCancel: () => {
          this.sound_stop_all()
          this.sound_play("click")
        },
      })
    },
    keyboard_handle() {
      this.sound_play("click")
      this.sound_stop_all()
      const dialog = this.$buefy.dialog.alert({
        title: "ショートカットキー",
        message: `
          <p class="mt-0"><b>左</b> → <code>左SHIFT</code> <code>左CONTROL</code> <code>TAB</code></p>
          <p class="mt-2"><b>右</b> → <code>右SHIFT</code> <code>右CONTROL</code> <code>ENTER</code> <code>↑↓←→</code></p>
        `,
        confirmText: "OK",
        canCancel: ["outside", "escape"],
        trapFocus: true,
        onConfirm: () => {
          this.sound_stop_all()
          this.sound_play("click")
        },
        onCancel: () => {
          this.sound_stop_all()
          this.sound_play("click")
        },
      })
    },
    dropdown_active_change(on) {
      if (on) {
        this.sound_play("click")
      } else {
        this.sound_play("click")
      }
    },
    rule_set(params) {
      params = {...params}
      this.__assert__("initial_main_min" in params, '"initial_main_min" in params')
      params.initial_main_sec = params.initial_main_min * 60
      this.clock_box.rule_set_all(params)
    },
  },
  computed: {
    base() { return this },
    CcRuleInfo() { return CcRuleInfo },
    mouse_cursor_hidden_p() {
      return this.clock_box.timer && !this.mouse_cursor_p
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "time_fields_default.sass"
@import "time_fields_desktop.sass"

.Xclock
  // ポーズのときのカバー
  .pause_bg
    position: fixed
    top: 0
    left: 0
    right: 0
    bottom: 0
    background-color: hsla(0, 0%, 0%, 0.7)
    z-index: 2

  .screen_container // 100vw x 100vh 相当の範囲
    height: 100vh   // 初期値(JSで上書きする)

    //////////////////////////////////////////////////////////////////////////////// カーソルを消す
    &.mouse_cursor_hidden_p
      cursor: none

    //////////////////////////////////////////////////////////////////////////////// 動作中は背景黒にする場合
    @at-root
      .is_xclock_active
        .screen_container // & と書きたい
          color: $white
          background-color: $black-ter
          .level-item
            &.is_sclock_inactive
              background-color: $black

    ////////////////////////////////////////////////////////////////////////////////

    // 停止ボタンを画面中央に配置
    .controll_button
      z-index: 2
      position: fixed
      top: 0
      left: 0
      right: 0
      bottom: 0
      margin: auto
      padding: 1.5rem
      border-radius: 50%
      color: $grey-lighter
      &.pause
        color: $grey
      &.resume, &.stop
        background-color: hsla(0, 50%, 100%, 0.2)
        background-color: change_color($primary, $alpha: 0.5)
      &.stop
        top: 50%
        +desktop
          top: 25%

    // .level を左右均等に配置
    flex-direction: column
    justify-content: space-between
    align-items: center

    // 半分を囲むブロック(つまりフッターを含まない)
    .level
      height: 100%
      width: 100%

      // 半分
      .level-item
        height: 100%
        width: 50%

        // 文字やフォームを中央縦並び配置
        flex-direction: column
        justify-content: space-between
        align-items: center

        // どちらがアクティブかを表すバー
        .active_current_bar, .inactive_current_bar
          height: 48px
          width: 100%
        .active_current_bar
          background-color: $primary

        // 時間表示(フォームも含む)
        .wide_container
          height: 100%
          width: 100%

          // 中央縦並び
          flex-direction: column
          justify-content: center
          align-items: center

          // 時間表示だけを囲むブロック
          &.time_fields
            @at-root
              .is_sclock_inactive
                .time_fields
                  opacity: 0.4
            .time_label
              font-weight: bold
            .time_value
              line-height: 1
              font-weight: bold
            // 1行表示
            &.display_lines-1
              .time_label
                display: none   // ラベル除去

          ////////////////////////////////////////////////////////////////////////////////
          &.form
            > .field
              margin-left: 1rem
              margin-right: 1rem
              &:not(:first-child)
            label
              margin-bottom: 0
            .b-numberinput
              margin-top: 0
              input
                min-width: 5rem
                +desktop
                  min-width: 8rem

  &.is_xclock_active
    .screen_container
      .active_current_bar
        &.is_level1
          background-color: $blue
          &.is_blink
            animation: xclock_bar_blink 1s ease-in-out 0.5s infinite alternate
        &.is_level2
          background-color: $yellow
          &.is_blink
            animation: xclock_bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.is_level3
          background-color: $red
          &.is_blink
            animation: xclock_bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.is_level4
          background-color: $red
          &.is_blink
            animation: xclock_bar_blink 0.25s ease-in-out 0.5s infinite alternate

@keyframes xclock_bar_blink
  0%
    opacity: 1.0
  100%
    opacity: 0.25

=xray($level)
  $color: hsla((360 / 8) * $level, 50%, 50%, 1.0)
  border: 2px solid $color

.STAGE-development
  .Xclock
    .screen_container
      .level
        +xray(0)
        .level-item
          +xray(1)
          .wide_container
            .field
              +xray(2)
            .time_fields
              .time_label
                +xray(3)
              .time_value
                +xray(4)
      .XclockAppFooter
        .item
          +xray(5)
</style>
