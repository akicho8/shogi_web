export const app_columns = {
  data() {
    return {
      visible_hash: null, //  { a: true, b: false } 形式
    }
  },
  methods: {
    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
      if (this.visible_hash[column.key]) {
        this.talk(column.name)
      }
    },
  },
}
