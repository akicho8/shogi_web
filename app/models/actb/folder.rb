# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (actb_folders as Actb::Folder)
#
# |------------+------------+-------------+-------------+--------------------+-------|
# | name       | desc       | type        | opts        | refs               | index |
# |------------+------------+-------------+-------------+--------------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |                    |       |
# | user_id    | User       | integer(8)  |             |                    | A! B  |
# | type       | 所属モデル | string(255) | NOT NULL    | SpecificModel(STI) | A!    |
# | created_at | 作成日時   | datetime    | NOT NULL    |                    |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |                    |       |
# |------------+------------+-------------+-------------+--------------------+-------|

module Actb
  class Folder < ApplicationRecord
    belongs_to :user

    has_many :questions, dependent: :destroy

    def name
      "#{user.name}の#{self.class.model_name.human}"
    end
  end
end
