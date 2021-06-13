export const app_style = {
  data() {
    return {
      touch_board_width: null, // touchデバイスでの将棋盤の幅(%)
      xy_grid_stroke:    null, // 線の太さ
      xy_grid_color:     null, // 線の色
    }
  },
  methods: {
    style_reset() {
      this.touch_board_width = null
      this.xy_grid_stroke = null
      this.xy_grid_color = null
    },
    style_default_handle() {
      this.sound_play("click")
      this.touch_board_width = this.ls_default.touch_board_width
      this.xy_grid_stroke    = this.ls_default.xy_grid_stroke
      this.xy_grid_color     = this.ls_default.xy_grid_color
    },
  },
  computed: {
    component_style() {
      return {
        "--touch_board_width": this.touch_board_width,
        "--xy_grid_stroke":    this.xy_grid_stroke,
        "--xy_grid_color":     this.xy_grid_color,
      }
    },
  },
}
