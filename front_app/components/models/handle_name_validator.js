import _ from "lodash"
import dayjs from "dayjs"
import { AnySupport } from "./any_support.js"
import { parse as TwitterEmojiParser } from 'twemoji-parser'

export const HandleNameValidator = {
  get MAX_LENGTH() { return 16 },

  // import { HandleNameValidator } from '@/components/models/handle_name_validator.js'
  //
  // const message = HandleNameValidator.valid_with_message(str, {name: "名前"})
  // if (message) {
  //   this.toast_warn(message)
  //   return
  // }
  //
  valid_with_message(s, options = {}) {
    options = {
      name: "ハンドルネーム",
      ...options,
    }
    s = _.trim(s)
    if (s.length === 0) {
      return `${options.name}を入力してください`
    }
    if (s.length > this.MAX_LENGTH) {
      return `${options.name}が長すぎます`
    }
    if (this.valid(s)) {
      return null
    } else {
      const pepper = dayjs().format("YYYY-MM-DD")
      const hash_number = AnySupport.hash_number_from_str([pepper, s].join("-"))
      const prefix = AnySupport.ary_cycle_at(this.prefix_list, hash_number)
      return `${prefix}${options.name}を入力してください`
    }
  },
  valid(s) {
    s = _.trim(s)
    s = AnySupport.hankaku_format(s)
    let error = false
    if (!error) {
      error = (s.length === 0)
    }
    if (!error) {
      error = (s.length > this.MAX_LENGTH)
    }
    if (!error) {
      error = s.match(/^\d+$/)
    }
    if (!error) {
      error = s.match(new RegExp(this.ng_words.join("|"), "i"))
    }
    if (!error) {
      error = (s.length <= 1 && !s.match(/[一-龠]/))
    }
    if (!error) {
      error = [...s].length === TwitterEmojiParser(s).length // すべて絵文字
    }
    return !error
  },
  get prefix_list() {
    return [
      "素敵な",
      "友好的な",
      "真面目に",
      "親近感のある",
      "フレンドリーな",
      "親しみのある",
      "捨てハンでない",
    ]
  },
  get ng_words() {
    return [
      ...this.prefix_list,
      "[な名][な無]し|nanash?i|無名|匿名|NONAME",
      "テスト|test|てすと",
      "名前|ハンドルネーム",
      "^あ+$",
      "戦犯",
      "初心者",
      "死",
      "通りすがり",
      "あいうえお",
      "ゴミ",
      "クズ",
      "クソ",
      "雑魚",
      "糞",
      "無駄",
      "時間",
      "。",
      "、",
      ",",
      "sex",
      "「",
      "」",
    ]
  },
}
