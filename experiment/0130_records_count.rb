#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp ActiveRecord::Base.connection.tables.collect { |table|
  [table, ActiveRecord::Base.connection.select_value("select count(*) from #{table}")]
}.to_h
# >> |------------------------------------+-----|
# >> |               ar_internal_metadata | 1   |
# >> |                    converted_infos | 184 |
# >> |          free_swars_battle_records | 31  |
# >> |             general_battle_records | 5   |
# >> |               general_battle_ships | 10  |
# >> |               general_battle_users | 10  |
# >> |                  schema_migrations | 14  |
# >> |                swars_battle_grades | 39  |
# >> |               swars_battle_records | 10  |
# >> |                 swars_battle_ships | 20  |
# >> |                 swars_battle_users | 11  |
# >> | swars_battle_user_receptions | 0   |
# >> |                           taggings | 409 |
# >> |                               tags | 120 |
# >> |------------------------------------+-----|
