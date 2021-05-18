import MemoryRecord from "js-memory-record"

export class KomaochiPresetInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "平手",           handicap_level:    59, sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", description: "ハンデなし", },
      { key: "飛車vs角",       handicap_level:    21, sfen: "position sfen lnsgkgsnl/1b5b1/ppppppppp/9/9/9/PPPPPPPPP/1R5R1/LNSGKGSNL w - 1", description: "1段級差", },
      { key: "香落ち",         handicap_level:   107, sfen: "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", description: "2段級差", },
      // { key: "右香落ち",    handicap_level:   107, sfen: "position sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", description: "あまり用いない", },
      { key: "角落ち",         handicap_level:   773, sfen: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "3段級差", },
      { key: "飛車落ち",       handicap_level:   810, sfen: "position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "4段級差", },
      { key: "飛香落ち",       handicap_level:   927, sfen: "position sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "5段級差", },
      { key: "新宿の殺し屋",   handicap_level:  1023, sfen: "position sfen 4k4/1r5r1/ppppppppp/9/9/9/PPPPPPPPP/9/LNSGKGSNL w - 1",           description: "5.5段級差", }, // 小池重明が用いたと噂の手合割
      { key: "二枚落ち",       handicap_level:  1876, sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "6〜7段級差", },
      // { key: "三枚落ち",    handicap_level:  2093, sfen: "position sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "8段級差", },
      { key: "四枚落ち",       handicap_level:  2285, sfen: "position sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "8〜9段級差", },
      { key: "六枚落ち",       handicap_level:  2803, sfen: "position sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",       description: "10段級差", },
      { key: "八枚落ち",       handicap_level:  4658, sfen: "position sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",         description: "13段級差", },
      { key: "先崎学九段推奨", handicap_level:  4898, sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w RB 1",    description: "14段級差", }, // 初心者に配慮した先崎学九段推奨の手合割", },
      { key: "十枚落ち",       handicap_level:  5783, sfen: "position sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",           description: "15段級差", },
      { key: "十九枚落ち",     handicap_level: 99999, sfen: "position sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",                   description: "16段級差", },
    ]
  }
}
