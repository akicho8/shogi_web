#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

obj = KifuParser.new(any_source: "嬉野流")
obj.params[:swars_battle_key] = "Yamada_Taro"
obj.to_all.keys                 # => [:kif, :ki2, :csa, :sfen, :bod]
puts obj.to_kif.lines.take(10)
# >> 詳細URL：http://0.0.0.0:4000/swars/battles/Yamada_Taro
# >> 先手の戦型：嬉野流
# >> 後手の戦型：原始棒銀, 棒銀
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車, 居玉
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ６八銀(79)   (00:00/00:00:00)
# >> *▲戦型：嬉野流
# >>    2 ３四歩(33)   (00:00/00:00:00)
