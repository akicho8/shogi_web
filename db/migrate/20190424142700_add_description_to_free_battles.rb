# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | name              | desc               | type           | opts        | refs                              | index |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)     | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)    | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)    |             |                                   |       |
# | kifu_body         | 棋譜               | text(16777215) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)     | NOT NULL    |                                   | F     |
# | meta_info         | 棋譜ヘッダー       | text(65535)    | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime       | NOT NULL    |                                   | E     |
# | outbreak_turn     | Outbreak turn      | integer(4)     |             |                                   | B     |
# | use_key           | Use key            | string(255)    | NOT NULL    |                                   | C     |
# | accessed_at       | Accessed at        | datetime       | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime       | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime       | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)     |             | :owner_user => Colosseum::User#id | D     |
# | title             | 題名               | string(255)    |             |                                   |       |
# | description       | 説明               | text(65535)    | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)     |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)     |             |                                   | G     |
# | saturn_key        | 公開範囲           | string(255)    | NOT NULL    |                                   | H     |
# | sfen_body         | SFEN形式棋譜       | string(8192)   |             |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)     |             |                                   |       |
# |-------------------+--------------------+----------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class AddDescriptionToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    change_table :free_battles do |t|
      t.text :description, null: false
    end
  end
end
