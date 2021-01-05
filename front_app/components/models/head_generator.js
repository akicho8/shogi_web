// SEO関連パラメータの設定例
//
//   export default {
//     computed: {
//       meta() {
//         return {
//           title: "タイトル",
//           description: "説明",
//           og_image_key: "foo",
//         }
//       }
//     },
//   }
//

import _ from "lodash"

export class HeadGenerator {
  constructor($config = {}, meta = {}) {
    this.$config = $config
    this.meta = meta
    this.h = {}
  }

  generate() {
    if (!this.meta) {
      return {}
    }

    this.h.meta = []

    this.ordered_fetch("title", ["title"])
    this.ordered_fetch("og:title", ["og_title", "title"])
    this.ordered_fetch("description", ["description"])
    this.ordered_fetch("og:description", ["og_description", "description"])

    this.image_set()

    if (this.meta.short_title) {
      this.h.titleTemplate = ""
    }

    if (this.meta.link) {
      this.h.link = this.meta.link
    }

    return this.h
  }

  //////////////////////////////////////////////////////////////////////////////// private

  image_set() {
    let s = null

    s = this.meta.og_image_key
    if (s) {
      s = this.$config.MY_NUXT_URL + `/ogp/${s}.png`
      this.set("og:image", s)
    }

    s = this.meta.og_image
    if (s) {
      s = this.$config.MY_SITE_URL + s
      this.set("og:image", s)
    }

    s = this.meta.twitter_card_is_small
    if (s) {
      this.set("twitter:card", "summary")
    }
  }

  ordered_fetch(hkey, keys) {
    const key = keys.find(e => e in this.meta) // 空文字列はスルーされてしまうので仕方なく has_key? でチェック
    if (key) {
      this.set(hkey, this.meta[key])
    }
  }

  set(key, val) {
    if (_.isArray(val)) {
      val = _.compact(val).join(" - ")
    }
    val = val || ""
    if (key === "title") {
      this.h.title = val
    } else {
      this.h.meta.push({hid: key, property: key, content: val})
    }
  }
}
