# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |--------------+--------------+-------------+-------------+------+---------|
# | name         | desc         | type        | opts        | refs | index   |
# |--------------+--------------+-------------+-------------+------+---------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |         |
# | battle_id    | 対局共通情報 | integer(8)  | NOT NULL    |      | A! B! C |
# | user_id      | ユーザー     | integer(8)  | NOT NULL    |      | B! D    |
# | grade_id     | 棋力         | integer(8)  | NOT NULL    |      | E       |
# | judge_key    | 結果         | string(255) | NOT NULL    |      | F       |
# | location_key | 先手or後手   | string(255) | NOT NULL    |      | A! G    |
# | position     | 順序         | integer(4)  |             |      | H       |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |         |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |         |
# | grade_diff   | Grade diff   | integer(4)  | NOT NULL    |      | I       |
# | think_max    | Think max    | integer(4)  |             |      |         |
# |--------------+--------------+-------------+-------------+------+---------|

require 'rails_helper'

module Swars
  RSpec.describe Battle::Membership, type: :model do
    before do
      Swars.setup
    end

    describe "タグ" do
      let :record do
        Battle.create!
      end
      it do
        assert { record.memberships[0].attack_tag_list  == ["嬉野流"]           }
        assert { record.memberships[1].attack_tag_list  == ["△３ニ飛戦法"]     }
        assert { record.memberships[0].defense_tag_list == []                   }
        assert { record.memberships[1].defense_tag_list == []                   }
        assert { record.memberships[0].note_tag_list    == ["居飛車", "居玉"]   }
        assert { record.memberships[1].note_tag_list    == ["振り飛車", "居玉"] }
      end
    end
  end
end
