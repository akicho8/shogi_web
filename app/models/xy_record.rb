# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | entry_name        | Entry name     | string(255) |             |                             |       |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) | NOT NULL    |                             | B     |
# | x_count           | X count        | integer(4)  | NOT NULL    |                             |       |
# | spent_sec         | Spent sec      | float(24)   | NOT NULL    |                             |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class XyRecord < ApplicationRecord
  ACCURACY = 3

  scope :entry_name_blank_scope, -> { where(entry_name: nil).where(arel_table[:created_at].lt(1.hour.ago) ) }

  belongs_to :user, class_name: "Colosseum::User", foreign_key: "colosseum_user_id", required: false

  before_validation do
    if summary
      self.summary = summary.to_s.squish
    end
    if entry_name
      self.entry_name = entry_name.to_s.squish.presence
    end

    # ランキングで同じ順位なのに表記が異なる場合があるのを避けるため
    if spent_sec
      self.spent_sec = spent_sec.floor(ACCURACY)
    end
  end

  with_options presence: true do
    validates :xy_rule_key
    validates :x_count
    validates :spent_sec
  end

  with_options allow_blank: true do
    validates :xy_rule_key, inclusion: XyRuleInfo.keys.collect(&:to_s)
  end

  after_create do
    ranking_add
  end

  after_destroy do
    ranking_rem
  end

  def rank(params)
    XyRuleInfo[xy_rule_key].rank_by_score(params, score)
  end

  def ranking_page(params)
    XyRuleInfo[xy_rule_key].ranking_page(params, id)
  end

  def score
    spent_sec * 10**ACCURACY * -1
  end

  def spent_sec_time_format
    "%d:%02d.%d" % [spent_sec / 60, spent_sec % 60, (spent_sec % 1) * 10**ACCURACY]
  end

  def slack_notify
    rank = rank(xy_scope_key: :xy_scope_all)
    SlackAgent.message_send(key: "符号", body: "[#{rank}位][#{entry_name}] #{summary}")
  end

  private

  def ranking_add
    XyRuleInfo[xy_rule_key].ranking_add(self)
  end

  def ranking_rem
    XyRuleInfo[xy_rule_key].ranking_rem(self)
  end
end
