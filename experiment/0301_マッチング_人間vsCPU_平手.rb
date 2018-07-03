#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user1 = User.create!
  user2 = User.create!(race_key: :robot)
  battle = user1.matching_start

  tp battle
  tp battle.memberships
  tp User
end
# >> I, [2018-07-03T18:04:51.010360 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (1887.05ms)
# >> I, [2018-07-03T18:04:51.037642 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.07ms)
# >> I, [2018-07-03T18:04:51.066153 #68946]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.71ms)
# >> I, [2018-07-03T18:04:51.081298 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.89ms)
# >> I, [2018-07-03T18:04:51.095438 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.73ms)
# >> I, [2018-07-03T18:04:51.102800 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.8ms)
# >> 1
# >> I, [2018-07-03T18:04:51.128981 #68946]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.15ms)
# >> I, [2018-07-03T18:04:51.132212 #68946]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.81ms)
# >> I, [2018-07-03T18:04:51.140486 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.4ms)
# >> I, [2018-07-03T18:04:51.146892 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.11ms)
# >> I, [2018-07-03T18:04:51.172188 #68946]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.08ms)
# >> I, [2018-07-03T18:04:51.178245 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.7ms)
# >> I, [2018-07-03T18:04:51.192895 #68946]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.81ms)
# >> I, [2018-07-03T18:04:51.202733 #68946]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (0.84ms)
# >> I, [2018-07-03T18:04:51.216876 #68946]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (7.11ms)
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |                  id | 59                                                                            |
# >> |    black_preset_key | 平手                                                                          |
# >> |    white_preset_key | 平手                                                                          |
# >> |        lifetime_key | lifetime_m5                                                                   |
# >> |         platoon_key | platoon_p1vs1                                                                 |
# >> |           full_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |        clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |     countdown_flags | {:black=>false, :white=>false}                                                |
# >> |            turn_max | 0                                                                             |
# >> |   battle_request_at |                                                                               |
# >> |     auto_matched_at | 2018-07-03 18:04:51 +0900                                                     |
# >> |            begin_at |                                                                               |
# >> |              end_at |                                                                               |
# >> |     last_action_key |                                                                               |
# >> |    win_location_key |                                                                               |
# >> | current_users_count | 0                                                                             |
# >> |   watch_ships_count | 0                                                                             |
# >> |          created_at | 2018-07-03 18:04:51 +0900                                                     |
# >> |          updated_at | 2018-07-03 18:04:51 +0900                                                     |
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | id  | battle_id | user_id | preset_key | location_key | position | standby_at                | fighting_at               | time_up_at | created_at                | updated_at                |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> | 217 |        59 |      36 | 平手       | black        |        0 | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |            | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |
# >> | 218 |        59 |      35 | 平手       | white        |        1 |                           |                           |            | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |
# >> |-----+-----------+---------+------------+--------------+----------+---------------------------+---------------------------+------------+---------------------------+---------------------------|
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id | key                              | name    | online_at                 | fighting_at               | matching_at | cpu_brain_key | user_agent | lifetime_key | platoon_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 35 | 64cc117fb72ad367efd78ffca6f2bb21 | 野良1号 | 2018-07-03 18:04:51 +0900 |                           |             |               |            | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            | accept           | human    | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |
# >> | 36 | 2e31f60e11f0830a7327f4f79e42a38e | CPU1号  | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |             |               |            | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-03 18:04:51 +0900 | 2018-07-03 18:04:51 +0900 |
# >> |----+----------------------------------+---------+---------------------------+---------------------------+-------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
