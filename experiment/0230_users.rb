#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp Fanta::User.all
# >> |----+---------+----------------------+---------------------------+---------------------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
# >> | id | name    | current_battle_room_id | online_at                 | fighting_at           | matching_at | lifetime_key  | self_preset_key | oppo_preset_key | created_at                | updated_at                |
# >> |----+---------+----------------------+---------------------------+---------------------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
# >> |  1 | 野良1号 |                      | 2018-05-06 18:17:31 +0900 |                           |             | lifetime_m5 | 平手          | 平手          | 2018-05-06 18:13:04 +0900 | 2018-05-06 18:17:31 +0900 |
# >> |  2 | 野良2号 |                    2 | 2018-05-06 18:16:16 +0900 | 2018-05-06 18:16:16 +0900 |             | lifetime_m5 | 平手          | 平手          | 2018-05-06 18:13:08 +0900 | 2018-05-06 18:16:16 +0900 |
# >> |----+---------+----------------------+---------------------------+---------------------------+-------------+---------------+---------------+---------------+---------------------------+---------------------------|
