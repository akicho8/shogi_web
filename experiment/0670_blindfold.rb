#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

free_battle = FreeBattle.same_body_fetch(body: "68銀")
free_battle.simple_versus_desc  # => "▲嬉野流 vs △その他"

# tp free_battle.tag_names_for(:attack) # => []
# free_battle.meta_info                 # => {:black=>{:defense=>[], :attack=>[:嬉野流], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}, :white=>{:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}}
# # Bioshogi::Location.each do |e|
# #   e.call_names                  # => ["先手", "下手"], ["後手", "上手"]
# # end
#
#
# info = Bioshogi::Parser.parse("68銀")
# free_battle.meta_info = info.mediator.players.inject({}) do |a, player|
#   a.merge(player.location.key => player.skill_set.to_h)
# end
# free_battle.save!
#
# tp free_battle.meta_info
#
# description = free_battle.meta_info.collect { |location_key, hash|
#   name = nil
#   name ||= hash[:attack].last
#   name ||= hash[:defense].last
#   name ||= "その他"
#   [Bioshogi::Location.fetch(location_key).mark, name].join
# }.join(" vs ")
# description                     # => "▲嬉野流 vs △その他"

# info.
# info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
# info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
# info.mediator.players.flat_map { |e| e.skill_set.technique_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
# info.mediator.players.flat_map { |e| e.skill_set.note_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }

# >> |-------+-------------------------------------------------------------------------------------------------|
# >> | black | {:defense=>[], :attack=>[:嬉野流], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]} |
# >> | white | {:defense=>[], :attack=>[], :technique=>[], :note=>[:居飛車, :相居飛車, :居玉, :相居玉]}        |
# >> |-------+-------------------------------------------------------------------------------------------------|
