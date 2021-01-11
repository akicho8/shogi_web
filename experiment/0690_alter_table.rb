#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

db = ActiveRecord::Base.connection.current_database # => "shogi_web_development"
tables = ActiveRecord::Base.connection.tables
tables.each do |table|
  sql = "alter table #{table} convert to character set utf8mb4 collate utf8mb4_bin"
  command = "mysql -u root #{db} -te '#{sql}'"
  puts command
  # ActiveRecord::Base.connection.execute(sql)
end

# `rails db:structure:dump`

# >> mysql -u root shogi_web_development -te 'alter table acns1_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table acns1_rooms convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_bad_marks convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_battle_memberships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_battles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_clip_marks convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_finals convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_folders convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_good_marks convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_histories convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_judges convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_lineages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_lobby_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_main_xrecords convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_moves_answers convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_ox_marks convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_ox_records convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_question_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_questions convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_room_memberships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_room_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_rooms convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_rules convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_season_xrecords convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_seasons convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_settings convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table actb_skills convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table active_storage_attachments convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table active_storage_blobs convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table alert_logs convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table ar_internal_metadata convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table auth_infos convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_battles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_chat_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_chronicles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_lobby_messages convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_memberships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_rules convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table colosseum_watch_ships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table cpu_battle_records convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table free_battles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table profiles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table schema_migrations convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table swars_battles convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table swars_grades convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table swars_memberships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table swars_search_logs convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table swars_users convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table taggings convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table tags convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table tsl_leagues convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table tsl_memberships convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table tsl_users convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table users convert to character set utf8mb4 collate utf8mb4_bin'
# >> mysql -u root shogi_web_development -te 'alter table time_records convert to character set utf8mb4 collate utf8mb4_bin'
