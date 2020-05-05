#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
user3 = Swars::User.create!

2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user2)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user2)
    e.memberships.build(user: user3)
  end
end
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user1)
    e.memberships.build(user: user3)
  end
end

# >> |----+----------+----------+-------------------+-------------------+---------------------------+---------------------------|
# >> | id | user_key | grade_id | last_reception_at | search_logs_count | created_at                | updated_at                |
# >> |----+----------+----------+-------------------+-------------------+---------------------------+---------------------------|
# >> | 36 | user1    |       40 |                   |                 0 | 2020-05-05 19:56:17 +0900 | 2020-05-05 19:56:19 +0900 |
# >> | 37 | user2    |       40 |                   |                 0 | 2020-05-05 19:56:17 +0900 | 2020-05-05 19:56:18 +0900 |
# >> | 38 | user3    |       40 |                   |                 0 | 2020-05-05 19:56:17 +0900 | 2020-05-05 19:56:19 +0900 |
# >> |----+----------+----------+-------------------+-------------------+---------------------------+---------------------------|
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | id | battle_id | user_id | grade_id | judge_key | location_key | position | created_at                | updated_at                | grade_diff | think_max | op_user_id | think_last | think_all_avg | think_end_avg | two_serial_max | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
# >> | 50 |        25 |      37 |       40 | lose      | white        |        1 | 2020-05-05 19:56:18 +0900 | 2020-05-05 19:56:18 +0900 |          0 |         7 |         36 |          7 |             5 |             5 |                |                  |                 |                    |               |                |
# >> | 52 |        26 |      37 |       40 | lose      | white        |        1 | 2020-05-05 19:56:18 +0900 | 2020-05-05 19:56:18 +0900 |          0 |         7 |         36 |          7 |             5 |             5 |                |                  |                 |                    |               |                |
# >> | 58 |        29 |      38 |       40 | lose      | white        |        1 | 2020-05-05 19:56:19 +0900 | 2020-05-05 19:56:19 +0900 |          0 |         7 |         36 |          7 |             5 |             5 |                |                  |                 |                    |               |                |
# >> | 60 |        30 |      38 |       40 | lose      | white        |        1 | 2020-05-05 19:56:19 +0900 | 2020-05-05 19:56:19 +0900 |          0 |         7 |         36 |          7 |             5 |             5 |                |                  |                 |                    |               |                |
# >> |----+-----------+---------+----------+-----------+--------------+----------+---------------------------+---------------------------+------------+-----------+------------+------------+---------------+---------------+----------------+------------------+-----------------+--------------------+---------------+----------------|
