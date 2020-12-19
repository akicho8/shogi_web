#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRecord.destroy_all

Timecop.freeze("2000-01-01") do
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.1, x_count: 0)
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.1, x_count: 0)
end

Timecop.freeze("2000-01-02") do
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.2, x_count: 0)
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 0.3, x_count: 0)
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.2, x_count: 0)
  XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 0.3, x_count: 0)

  XyRuleInfo.redis.flushdb
  XyRuleInfo[:xy_rule1].aggregate

  tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "false")
  tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_all", entry_name_uniq_p: "true")
  tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "false")
  tp XyRuleInfo[:xy_rule1].xy_records(xy_scope_key: "xy_scope_today", entry_name_uniq_p: "true")
end

# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | id   | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                    | updated_at                    | rank |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | 1979 |                   | b          |         | xy_rule1    |       0 |       0.1 | 2000-01-01T00:00:00.000+09:00 | 2000-01-01T00:00:00.000+09:00 |    1 |
# >> | 1978 |                   | a          |         | xy_rule1    |       0 |       0.1 | 2000-01-01T00:00:00.000+09:00 | 2000-01-01T00:00:00.000+09:00 |    1 |
# >> | 1982 |                   | b          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    3 |
# >> | 1980 |                   | a          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    3 |
# >> | 1983 |                   | b          |         | xy_rule1    |       0 |       0.3 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    5 |
# >> | 1981 |                   | a          |         | xy_rule1    |       0 |       0.3 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    5 |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | id   | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                    | updated_at                    | rank |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | 1979 |                   | b          |         | xy_rule1    |       0 |       0.1 | 2000-01-01T00:00:00.000+09:00 | 2000-01-01T00:00:00.000+09:00 |    1 |
# >> | 1978 |                   | a          |         | xy_rule1    |       0 |       0.1 | 2000-01-01T00:00:00.000+09:00 | 2000-01-01T00:00:00.000+09:00 |    1 |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | id   | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                    | updated_at                    | rank |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | 1982 |                   | b          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    1 |
# >> | 1980 |                   | a          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    1 |
# >> | 1983 |                   | b          |         | xy_rule1    |       0 |       0.3 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    3 |
# >> | 1981 |                   | a          |         | xy_rule1    |       0 |       0.3 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    3 |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | id   | colosseum_user_id | entry_name | summary | xy_rule_key | x_count | spent_sec | created_at                    | updated_at                    | rank |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
# >> | 1982 |                   | b          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    1 |
# >> | 1980 |                   | a          |         | xy_rule1    |       0 |       0.2 | 2000-01-02T00:00:00.000+09:00 | 2000-01-02T00:00:00.000+09:00 |    1 |
# >> |------+-------------------+------------+---------+-------------+---------+-----------+-------------------------------+-------------------------------+------|
