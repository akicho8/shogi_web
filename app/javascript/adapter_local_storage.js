// 超簡単に変数を永続化するテンプレートメソッドパターン
//
// 使う側で書くこと
//
//   import adapter_local_storage from "adapter_local_storage.js"
//
//   {
//     mixins: [adapter_local_storage],
//
//     data() {
//       return {
//         my_var1: null, // ここの値は意味ないので null でよい
//       }
//     },
//
//     computed: {
//       ls_key() {
//         return "my_app" // localStorage のキー
//       },
//
//       ls_data() {
//         return {
//           my_var1: false, // 初期値
//         }
//       },
//     },
//   }
//
export default {
  created() {
    this.$_ls_load()
    this.$watch(() => this.$_ls_watch_values, () => this.$_ls_save(), {deep: true}) // 変数がハッシュかもしれないので deep: true にしておく
  },

  methods: {
    $_ls_save() {
      if (this.development_p) {
        console.log("$_ls_save", this.$_ls_hash)
      }
      localStorage.setItem(this.ls_key, JSON.stringify(this.$_ls_hash))
    },

    $_ls_load() {
      let v = {}
      const value = localStorage.getItem(this.ls_key)
      if (value) {
        v = JSON.parse(value)
      }
      if (this.development_p) {
        console.log("$_ls_load", v)
      }
      this.$_ls_set_vars(v)
    },

    $_ls_set_vars(v) {
      this.$_ls_data_keys.forEach(e => {
        this[e] = (v[e] != null) ? v[e] : this.ls_data[e]
      })
    },

    $_ls_reset() {
      localStorage.removeItem(this.ls_key)
      this.$_ls_load()
    },
  },

  computed: {
    ls_key() {
      alert("ls_key is not implemented")
    },

    ls_data() {
      alert("ls_data is not implemented")
    },

    $_ls_data_keys() {
      return Object.keys(this.ls_data)
    },

    $_ls_watch_values() {
      return this.$_ls_data_keys.map(e => this[e])
    },

    // ハッシュ型にした保存するデータ
    $_ls_hash() {
      return this.$_ls_data_keys.reduce((a, e) => ({...a, [e]: this[e]}), {})
    },
  },
}
