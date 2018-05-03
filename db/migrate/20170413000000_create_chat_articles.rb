# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 件名と本文のみテーブル (chat_articles as ChatArticle)
#
# +------------+----------+----------+-------------+------+-------+
# | カラム名   | 意味     | タイプ   | 属性        | 参照 | INDEX |
# +------------+----------+----------+-------------+------+-------+
# | id         | ID       | integer  | NOT NULL PK |      |       |
# | subject    | 件名     | string   |             |      |       |
# | body       | 内容     | text     |             |      |       |
# | created_at | 作成日時 | datetime | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime | NOT NULL    |      |       |
# +------------+----------+----------+-------------+------+-------+

class CreateChatArticles < ActiveRecord::Migration[5.1]
  def up
    create_table :chat_users, force: true do |t|
      t.string :name, null: false
      t.belongs_to :current_chat_room, null: true
      t.datetime :appearing_at
      t.datetime :matching_at
      t.timestamps null: false
    end
    create_table :chat_rooms, force: true do |t|
      t.belongs_to :room_owner, null: false
      t.string :preset_key, null: false
      t.string :motijikan_key, null: false
      t.string :name, null: false
      t.text :kifu_body_sfen, null: false
      t.text :clock_counts, null: false
      t.integer :current_chat_users_count, default: 0
      t.integer :turn_max, null: false
      t.datetime :battle_started_at
      t.datetime :battle_ended_at
      t.string :win_location_key, null: true
      t.timestamps null: false
    end
    create_table :chat_memberships, force: true do |t|
      t.belongs_to :chat_room, null: false
      t.belongs_to :chat_user, null: false
      t.string :location_key, null: true, index: true, comment: "▲△"
      t.integer :position, index: true, comment: "入室順序"
      t.timestamps null: false
    end
    create_table :chat_articles, force: true do |t|
      t.belongs_to :chat_room, null: false, comment: "部屋"
      t.belongs_to :chat_user, null: false, comment: "人"
      t.text :message, null: false
      t.timestamps null: false
    end
  end
end
