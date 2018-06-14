# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (users as Fanta::User)
#
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照             | INDEX |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                  |       |
# | name                   | 名前                | string(255) | NOT NULL    |                  |       |
# | current_battle_room_id | Current battle room | integer(8)  |             | => Fanta::BattleRoom#id | A     |
# | online_at              | Online at           | datetime    |             |                  |       |
# | fighting_at            | Fighting at         | datetime    |             |                  |       |
# | matching_at            | Matching at         | datetime    |             |                  |       |
# | lifetime_key           | Lifetime key        | string(255) | NOT NULL    |                  | B     |
# | platoon_key            | Platoon key         | string(255) | NOT NULL    |                  | C     |
# | self_preset_key        | Self preset key     | string(255) | NOT NULL    |                  | D     |
# | oppo_preset_key        | Oppo preset key     | string(255) | NOT NULL    |                  | E     |
# | user_agent             | Fanta::User agent          | string(255) | NOT NULL    |                  |       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                  |       |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                  |       |
# |------------------------+---------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・User モデルは Fanta::BattleRoom モデルから has_many :current_users, :foreign_key => :current_battle_room_id されています。
#--------------------------------------------------------------------------------

class Swars::User < ApplicationRecord
  has_many :memberships, dependent: :destroy      # 対局時の情報(複数)
  has_many :battles, through: :memberships # 対局(複数)
  belongs_to :grade                         # すべてのモードのなかで一番よい段級位
  has_many :search_logs, dependent: :destroy   # 明示的に取り込んだ日時の記録

  before_validation do
    self.grade ||= Swars::Grade.last

    # Swars::Grade が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:grade_id]
      ov, nv = changes[:grade_id]
      if ov && nv
        if Swars::Grade.find(ov).priority < Swars::Grade.find(nv).priority
          self.grade_id = ov
        end
      end
    end
  end

  with_options presence: true do
    validates :user_key
  end

  with_options allow_blank: true do
    validates :user_key, uniqueness: true
  end

  def to_param
    user_key
  end
end
