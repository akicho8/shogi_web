# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (emox_battles as Emox::Battle)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | room_id    | Room       | integer(8) | NOT NULL    |      | A     |
# | parent_id  | Parent     | integer(8) |             |      | B     |
# | rule_id    | Rule       | integer(8) | NOT NULL    |      | C     |
# | final_id   | Final      | integer(8) | NOT NULL    |      | D     |
# | begin_at   | Begin at   | datetime   | NOT NULL    |      | E     |
# | end_at     | End at     | datetime   |             |      | F     |
# | battle_pos | Battle pos | integer(4) | NOT NULL    |      | G     |
# | practice   | Practice   | boolean    |             |      |       |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

# user1 = User.create!
# user2 = User.create!
#
# battle = Emox::Battle.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end
#
# battle.room_messages.create!(user: user1, body: "a") # => #<Emox::RoomMessage id: 1, user_id: 31, battle_id: 18, body: "a", created_at: "2020-05-05 07:18:46", updated_at: "2020-05-05 07:18:46">
#
module Emox
  class Battle < ApplicationRecord
    belongs_to :room, counter_cache: true
    belongs_to :final
    belongs_to :rule

    has_many :memberships, -> { order(:position) }, class_name: "BattleMembership", dependent: :destroy, inverse_of: :battle
    has_many :users, through: :memberships
    belongs_to :parent, class_name: "Battle", optional: true # 連戦したときの前の部屋

    has_one :vs_record, dependent: :destroy, inverse_of: :battle # 対局したときの棋譜

    before_validation do
      if room
        self.rule ||= room.rule
      end

      if parent
        self.battle_pos ||= parent.battle_pos + 1 # FIXME: これいらない？
      end

      self.final ||= Final.fetch(:f_pending)
      if will_save_change_to_attribute?(:final_id) && final && final.key != "f_pending"
        self.end_at ||= Time.current
      end

      self.begin_at ||= Time.current
      self.rule ||= Rule.fetch(RuleInfo.default_key)
      self.battle_pos ||= 0
    end

    with_options presence: true do
      validates :begin_at
    end

    after_create_commit do
      Emox::BattleBroadcastJob.perform_later(self)
    end

    def final_info
      final.pure_info
    end

    def battle_chain_create
      room.battle_create_with_members!(parent: self) # --> app/jobs/emox/battle_broadcast_job.rb
    end

    def judge_final_set(target_user, judge_key, final_key)
      BattleJudgeFinalSet.new(self, {
          :target_user => target_user,
          :judge_key   => judge_key,
          :final_key   => final_key,
        }).run
    end

    # 開始時
    def as_json_type1
      as_json({
          only: [:id, :battle_pos],
          include: {
            final: { only: [:key], methods: [:name] },
            room: {},
            memberships: {
              only: [:id, :position],
              methods: [:location_key],
              include: {
                user: {
                  only: [:id],
                },
              },
            },
          },
        })
    end

    # 結果表示時
    def as_json_type2_for_result
      as_json({
          only: [:id, :battle_pos],
          include: {
            final: {
              only: [:key],
              methods: [:name, :lose_side]
            },
            memberships: {
              only: [:id, :position],
              include: {
                user: {
                  only: [:id],
                },
                judge: {
                  only: [:key, :name],
                },
              },
            }
          }
        })
    end
  end
end
