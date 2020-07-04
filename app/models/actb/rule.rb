# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (actb_rules as Actb::Rule)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Actb
  class Rule < ApplicationRecord
    class << self
      # 全削除(トリガーなし・デバッグ用)
      def matching_users_clear
        if RuleInfo.any? { |e| redis.del(e.redis_key) >= 1 }
          matching_users_broadcast
        end
      end

      # すべてのルールから除去(トリガーあり)
      def matching_users_delete_from_all_rules(user)
        RuleInfo.each { |e| e.matching_users_delete(user) }
      end

      # JS側に渡す値
      def matching_users_hash
        RuleInfo.inject({}) do |a, e|
          a.merge(e.key => redis.smembers(e.redis_key).collect(&:to_i))
        end
      end

      # 配信
      def matching_users_broadcast(params = {})
        bc_params = {
          matching_users_hash: matching_users_hash,
        }.merge(params)

        ActionCable.server.broadcast("actb/lobby_channel", bc_action: :matching_users_broadcasted, bc_params: bc_params)
      end

      def redis
        Actb::BaseChannel.redis
      end
    end

    include StaticArModel

    delegate :redis_key, :time_limit_sec, to: :pure_info
    delegate :redis, :matching_users_broadcast, to: "self.class"

    with_options(dependent: :destroy) do
      has_many :settings
      has_many :rooms
      has_many :battles
    end

    def matching_user_ids
      redis.smembers(redis_key).collect(&:to_i)
    end

    def matching_users
      matching_user_ids.collect { |e| User.find(e) }
    end

    def matching_users_include?(user)
      redis.sismember(redis_key, user.id)
    end

    def matching_users_add(user)
      if redis.sadd(redis_key, user.id) # 新規で追加できたときだけ真
        matching_users_broadcast(trigger: :add, user_id: user.id)
      end
    end

    # このルール内で user を解除
    def matching_users_delete(user)
      if user
        if redis.srem(redis_key, user.id) # 既存のIDを削除できたときだけ真
          matching_users_broadcast(trigger: :delete, user_id: user.id) # このトリガーは未使用
        end
      end
    end
  end
end
