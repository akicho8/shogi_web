export default {
  methods: {
    // いちばん簡単なインターフェイス
    simple_clipboard_copy(text) {
      this.clipboard_copy({text: text})
    },

    // Rails の通常のビューから使う用
    // とても使いにくい
    kif_clipboard_copy_for_rails_view(e) {
      const params = JSON.parse(e.target.dataset[_.camelCase("kifu_copy_params")])
      this.kif_clipboard_copy(params)
    },

    // 指定 URL の結果をクリップボードにコピー
    // 引数の params を更新していって前回取得したテキストを保存し、2度目からはajaxしない
    kif_clipboard_copy(params) {
      if (params.text) {
        this.debug_alert("パラメータにテキストが含まれる")
        this.clipboard_copy(params)
        return
      }

      if (params.kc_path) {
        const kc_format = params.kc_format || "kif"
        const full_url = `${params.kc_path}.${kc_format}`

        this.http_get_command(full_url, {}, data => {
          this.debug_alert("AJAX後にテキスト取得")
          params.text = data
          this.clipboard_copy(params)
        })

        return
      }

      alert("must not happen")
    },

    // params.text をクリップボードにコピー
    // params を破壊する
    // params をずっと保持していれば1,2度目で挙動がかわる
    clipboard_copy(params) {
      if (params.success_message  == null) { params.success_message  = "コピーしました"                                           }
      if (params.failure_message1 == null) { params.failure_message1 = "なぜか最初だけ失敗するのでもう一回タップしてみてください" }
      if (params.failure_message2 == null) { params.failure_message2 = "失敗しました。もう何回やってもダメそうです"               }

      let success = false

      if (true) {
        // この方法は iPhone で動かない。先に elem.select() を実行した時点で iPhone の方が作動しなくなる
        if (false) {
          const el = document.createElement("textarea")
          el.value = params.text
          document.body.appendChild(el)
          el.select() // この方法は Windows Chrome でのみ動く
          success = document.execCommand("copy") // なんの嫌がらせか実際にクリックしていないと動作しないので注意
          console.log(`クリップボードコピー試行1: select => ${success}`)

          if (!success) {
            // この方法は iPhone と Mac の Chrome で動く。Mac の Safari では未検証
            const range = document.createRange()
            range.selectNode(el)
            window.getSelection().addRange(range)
            success = document.execCommand("copy")
            console.log(`クリップボードコピー試行2: selectNode => ${success}`)
          }

          document.body.removeChild(el)
        }

        // https://marmooo.blogspot.com/2018/02/javascript.html
        if (true) {
          const el = document.createElement('textarea')
          document.body.appendChild(el)
          el.value = params.text
          success = this.corresponded_to_ios_pc_android_copy_to_clipboard(el)
          document.body.removeChild(el)
        }

        if (!success) {
          params.error_counter = (params.error_counter || 0) + 1
          if (params.error_dialog_enable) {
            this.clipboard_copy_error_dialog(params)
          } else {
            if (params.error_counter == 1) {
              this.talk(params.failure_message1, {rate: 1.5})
              this.$buefy.toast.open({message: params.failure_message1, position: "is-bottom", queue: false, type: "is-warning"})
            }
            if (params.error_counter >= 2) {
              this.talk(params.failure_message2, {rate: 1.5})
              this.$buefy.toast.open({message: params.failure_message2, position: "is-bottom", queue: false, type: "is-danger"})
              this.clipboard_copy_error_dialog(params)
            }
          }
          return
        }

        this.talk(params["success_message"], {rate: 1.5})
        this.$buefy.toast.open({message: params["success_message"], position: "is-bottom", queue: false, type: "is-success"})
      }

      // この方法は Windows Chrome で必ず失敗するというか navigator.clipboard が定義されてないので激指をメインで使う人は異様に使いにくくなってしまう
      // https://alligator.io/js/async-clipboard-api/
      //
      // PC Safari, iOS Safari も対応してない
      // https://developer.mozilla.org/ja/docs/Web/API/Navigator/clipboard
      if (false) {
        if (navigator.clipboard) {
          navigator.clipboard.writeText(params.text).then(() => {
            this.talk(params["success_message"])
            this.$buefy.toast.open({message: params["success_message"], position: "is-bottom", queue: false, type: "is-success"})
          }).catch(err => {
            this.clipboard_copy_error_dialog(params)
          })
        } else {
          this.clipboard_copy_error_dialog(params)
        }
      }
    },

    clipboard_copy_error_dialog(params) {
      // this.talk(params["failure_message"], {rate: 2.0})
      // this.$buefy.toast.open({message: params["failure_message"], position: "is-bottom", queue: false, type: "is-danger"})

      this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        fullScreen: false,
        component: {
          mounted() {
            const el = this.$refs.text_copy_textarea.$refs.textarea
            el.focus()
            el.select()
            el.scrollTop = 0
          },
          template: `
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">棋譜のコピーに失敗しました</p>
              </header>
              <section class="modal-card-body">
                <p><small>こちらから手動でコピーしてみてください</small></p>
                <b-field label="">
                  <b-input type="textarea" value="${params['text']}" ref="text_copy_textarea" rows="20" size="is-small"></b-input>
                </b-field>
              </section>
              <footer class="modal-card-foot">
                <button class="button" type="button" @click="$parent.close()">閉じる</button>
              </footer>
            </div>`,
        },
      })
    },

    // https://marmooo.blogspot.com/2018/02/javascript.html
    corresponded_to_ios_pc_android_copy_to_clipboard(el) {
      // resolve the element
      el = (typeof el === 'string') ? document.querySelector(el) : el

      // handle iOS as a special case
      if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
        // save current contentEditable/readOnly status
        const editable = el.contentEditable
        const readOnly = el.readOnly

        // convert to editable with readonly to stop iOS keyboard opening
        el.contentEditable = true
        el.readOnly = true

        // create a selectable range
        const range = document.createRange()
        range.selectNodeContents(el)

        // select the range
        const selection = window.getSelection()
        selection.removeAllRanges()
        selection.addRange(range)
        el.setSelectionRange(0, 999999)

        // restore contentEditable/readOnly to original state
        el.contentEditable = editable
        el.readOnly = readOnly
      } else {
        el.select()
      }

      // execute copy command
      return document.execCommand('copy')
    },
  },
}
