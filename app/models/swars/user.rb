# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザー (swars_users as Swars::User)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | user_key          | User key          | string(255) | NOT NULL    |      | A!    |
# | grade_id          | Grade             | integer(8)  | NOT NULL    |      | B     |
# | last_reception_at | Last reception at | datetime    |             |      | C     |
# | search_logs_count | Search logs count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      | D     |
# |-------------------+-------------------+-------------+-------------+------+-------|

module Swars
  class User < ApplicationRecord
    alias_attribute :key, :user_key

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)
    belongs_to :grade                          # すべてのモードのなかで一番よい段級位
    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    before_validation do
      self.user_key ||= SecureRandom.hex
      self.grade ||= Grade.last

      # Grade が下がらないようにする
      # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
      if changes_to_save[:grade_id]
        ov, nv = changes_to_save[:grade_id]
        if ov && nv
          if Grade.find(ov).priority < Grade.find(nv).priority
            self.grade_id = ov
          end
        end
      end
    end

    with_options presence: true do
      validates :user_key
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: { case_sensitive: true }
    end

    def to_param
      user_key
    end

    def swars_home_url
      Rails.application.routes.url_helpers.swars_home_url(self)
    end

    def name_with_grade
      "#{user_key} #{grade.name}"
    end

    concerning :SummaryMethods do
      included do
        delegate :basic_summary, :secret_summary, :tactic_summary_for, to: :summary_info
      end

      def summary_info
        @summary_info ||= SummaryInfo.new(self)
      end
    end

    concerning :ScopeMethods do
      included do
        scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc) } # よく使ってくれる人
        scope :regular_only, -> { order(search_logs_count: :desc) }                                  # よく使ってくれる人
        scope :great_only, -> { joins(:grade).order(Swars::Grade.arel_table[:priority].desc).order(:updated_at => :desc) } # すごい人
      end

      class_methods do
        def search_form_datalist
          Rails.cache.fetch("search_form_datalist", expires_in: Rails.env.production? ? 1.days : 0) do
            user_keys = []

            # 利用者
            user_keys += recently_only.limit(10).pluck(:user_key)

            # 最近取り込んだ人たち
            user_keys += all.order(updated_at: :desc).limit(10).pluck(:user_key)

            # すごい人たち
            user_keys += Rails.cache.fetch("great_only", expires_in: Rails.env.production? ? 1.days : 0) { great_only.limit(10).pluck(:user_key) }

            user_keys.uniq
          end
        end
      end
    end
  end
end
