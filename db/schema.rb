# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_11_090941) do

  create_table "actb_bad_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_actb_bad_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_actb_bad_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_actb_bad_marks_on_user_id"
  end

  create_table "actb_battle_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対戦"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "judge_id", null: false, comment: "勝敗"
    t.integer "position", null: false, comment: "順序"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id", "user_id"], name: "index_actb_battle_memberships_on_battle_id_and_user_id", unique: true
    t.index ["battle_id"], name: "index_actb_battle_memberships_on_battle_id"
    t.index ["judge_id"], name: "index_actb_battle_memberships_on_judge_id"
    t.index ["position"], name: "index_actb_battle_memberships_on_position"
    t.index ["user_id"], name: "index_actb_battle_memberships_on_user_id"
  end

  create_table "actb_battles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "room_id", null: false, comment: "部屋"
    t.bigint "parent_id", comment: "親"
    t.bigint "rule_id", null: false, comment: "ルール"
    t.bigint "final_id", null: false, comment: "結果"
    t.datetime "begin_at", null: false, comment: "対戦開始日時"
    t.datetime "end_at", comment: "対戦終了日時"
    t.integer "battle_pos", null: false, comment: "連戦インデックス"
    t.boolean "practice", comment: "練習バトル？"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_pos"], name: "index_actb_battles_on_battle_pos"
    t.index ["begin_at"], name: "index_actb_battles_on_begin_at"
    t.index ["end_at"], name: "index_actb_battles_on_end_at"
    t.index ["final_id"], name: "index_actb_battles_on_final_id"
    t.index ["parent_id"], name: "index_actb_battles_on_parent_id"
    t.index ["room_id"], name: "index_actb_battles_on_room_id"
    t.index ["rule_id"], name: "index_actb_battles_on_rule_id"
  end

  create_table "actb_clip_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_actb_clip_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_actb_clip_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_actb_clip_marks_on_user_id"
  end

  create_table "actb_emotion_folders", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_emotion_folders_on_position"
  end

  create_table "actb_emotions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "所有者"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "name", null: false, comment: "トリガー名"
    t.string "message", null: false, comment: "表示用伝言"
    t.string "voice", null: false, comment: "発声用文言"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_actb_emotions_on_folder_id"
    t.index ["position"], name: "index_actb_emotions_on_position"
    t.index ["user_id"], name: "index_actb_emotions_on_user_id"
  end

  create_table "actb_finals", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_finals_on_position"
  end

  create_table "actb_folders", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false, comment: "for STI"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "user_id"], name: "index_actb_folders_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_actb_folders_on_user_id"
  end

  create_table "actb_good_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_actb_good_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_actb_good_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_actb_good_marks_on_user_id"
  end

  create_table "actb_histories", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.bigint "room_id", comment: "対戦部屋"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ox_mark_id", null: false, comment: "解答"
    t.index ["ox_mark_id"], name: "index_actb_histories_on_ox_mark_id"
    t.index ["question_id"], name: "index_actb_histories_on_question_id"
    t.index ["room_id"], name: "index_actb_histories_on_room_id"
    t.index ["user_id"], name: "index_actb_histories_on_user_id"
  end

  create_table "actb_judges", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_judges_on_position"
  end

  create_table "actb_lineages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_lineages_on_position"
  end

  create_table "actb_lobby_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_actb_lobby_messages_on_user_id"
  end

  create_table "actb_main_xrecords", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "judge_id", null: false, comment: "直前の勝敗"
    t.bigint "final_id", null: false, comment: "直前の結果"
    t.integer "battle_count", null: false, comment: "対戦数"
    t.integer "win_count", null: false, comment: "勝ち数"
    t.integer "lose_count", null: false, comment: "負け数"
    t.float "win_rate", null: false, comment: "勝率"
    t.float "rating", null: false, comment: "レーティング"
    t.float "rating_diff", null: false, comment: "直近レーティング変化"
    t.float "rating_max", null: false, comment: "レーティング(最大)"
    t.integer "straight_win_count", null: false, comment: "連勝数"
    t.integer "straight_lose_count", null: false, comment: "連敗数"
    t.integer "straight_win_max", null: false, comment: "連勝数(最大)"
    t.integer "straight_lose_max", null: false, comment: "連敗数(最大)"
    t.bigint "skill_id", null: false, comment: "ウデマエ"
    t.float "skill_point", null: false, comment: "ウデマエの内部ポイント"
    t.float "skill_last_diff", null: false, comment: "直近ウデマエ変化度"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disconnect_count", null: false, comment: "切断数"
    t.datetime "disconnected_at", comment: "最終切断日時"
    t.index ["battle_count"], name: "index_actb_main_xrecords_on_battle_count"
    t.index ["disconnect_count"], name: "index_actb_main_xrecords_on_disconnect_count"
    t.index ["final_id"], name: "index_actb_main_xrecords_on_final_id"
    t.index ["judge_id"], name: "index_actb_main_xrecords_on_judge_id"
    t.index ["lose_count"], name: "index_actb_main_xrecords_on_lose_count"
    t.index ["rating"], name: "index_actb_main_xrecords_on_rating"
    t.index ["rating_diff"], name: "index_actb_main_xrecords_on_rating_diff"
    t.index ["rating_max"], name: "index_actb_main_xrecords_on_rating_max"
    t.index ["skill_id"], name: "index_actb_main_xrecords_on_skill_id"
    t.index ["straight_lose_count"], name: "index_actb_main_xrecords_on_straight_lose_count"
    t.index ["straight_lose_max"], name: "index_actb_main_xrecords_on_straight_lose_max"
    t.index ["straight_win_count"], name: "index_actb_main_xrecords_on_straight_win_count"
    t.index ["straight_win_max"], name: "index_actb_main_xrecords_on_straight_win_max"
    t.index ["user_id"], name: "index_actb_main_xrecords_on_user_id", unique: true
    t.index ["win_count"], name: "index_actb_main_xrecords_on_win_count"
    t.index ["win_rate"], name: "index_actb_main_xrecords_on_win_rate"
  end

  create_table "actb_moves_answers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_id", null: false, comment: "問題"
    t.integer "moves_count", null: false, comment: "N手"
    t.string "moves_str", null: false, comment: "連続した指し手"
    t.string "end_sfen", comment: "最後の局面"
    t.string "moves_human_str", comment: "人間向け指し手"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["moves_count"], name: "index_actb_moves_answers_on_moves_count"
    t.index ["question_id"], name: "index_actb_moves_answers_on_question_id"
  end

  create_table "actb_notifications", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_message_id", null: false, comment: "問題コメント"
    t.bigint "user_id", null: false, comment: "通知先"
    t.datetime "opened_at", comment: "開封日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_message_id"], name: "index_actb_notifications_on_question_message_id"
    t.index ["user_id"], name: "index_actb_notifications_on_user_id"
  end

  create_table "actb_ox_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false, comment: "正解・不正解"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_actb_ox_marks_on_key"
    t.index ["position"], name: "index_actb_ox_marks_on_position"
  end

  create_table "actb_ox_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_id", null: false, comment: "問題"
    t.integer "o_count", null: false, comment: "正解数"
    t.integer "x_count", null: false, comment: "不正解数"
    t.integer "ox_total", null: false, comment: "出題数"
    t.float "o_rate", comment: "高評価率"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["o_count"], name: "index_actb_ox_records_on_o_count"
    t.index ["o_rate"], name: "index_actb_ox_records_on_o_rate"
    t.index ["ox_total"], name: "index_actb_ox_records_on_ox_total"
    t.index ["question_id"], name: "index_actb_ox_records_on_question_id", unique: true
    t.index ["x_count"], name: "index_actb_ox_records_on_x_count"
  end

  create_table "actb_question_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "発言者"
    t.bigint "question_id", null: false, comment: "問題"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_actb_question_messages_on_question_id"
    t.index ["user_id"], name: "index_actb_question_messages_on_user_id"
  end

  create_table "actb_questions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.bigint "lineage_id", null: false, comment: "種類"
    t.string "init_sfen", null: false, comment: "問題"
    t.integer "time_limit_sec", comment: "制限時間(秒)"
    t.integer "difficulty_level", comment: "難易度"
    t.string "title", comment: "タイトル"
    t.string "description", limit: 512, comment: "説明"
    t.string "hint_desc", comment: "ヒント"
    t.string "source_author", comment: "作者"
    t.string "source_media_name", comment: "出典メディア"
    t.string "source_media_url", comment: "出典URL"
    t.date "source_published_on", comment: "出典年月日"
    t.bigint "source_about_id", comment: "所在"
    t.integer "turn_max", comment: "最大手数"
    t.boolean "mate_skip", comment: "詰みチェックをスキップする"
    t.string "direction_message", comment: "メッセージ"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "good_rate", comment: "高評価率"
    t.integer "moves_answers_count", default: 0, null: false, comment: "解答数"
    t.integer "histories_count", default: 0, null: false, comment: "履歴数(出題数とは異なる)"
    t.integer "good_marks_count", default: 0, null: false, comment: "高評価数"
    t.integer "bad_marks_count", default: 0, null: false, comment: "低評価数"
    t.integer "clip_marks_count", default: 0, null: false, comment: "保存された数"
    t.integer "messages_count", default: 0, null: false, comment: "コメント数"
    t.index ["bad_marks_count"], name: "index_actb_questions_on_bad_marks_count"
    t.index ["clip_marks_count"], name: "index_actb_questions_on_clip_marks_count"
    t.index ["difficulty_level"], name: "index_actb_questions_on_difficulty_level"
    t.index ["folder_id"], name: "index_actb_questions_on_folder_id"
    t.index ["good_marks_count"], name: "index_actb_questions_on_good_marks_count"
    t.index ["good_rate"], name: "index_actb_questions_on_good_rate"
    t.index ["histories_count"], name: "index_actb_questions_on_histories_count"
    t.index ["init_sfen"], name: "index_actb_questions_on_init_sfen"
    t.index ["key"], name: "index_actb_questions_on_key"
    t.index ["lineage_id"], name: "index_actb_questions_on_lineage_id"
    t.index ["messages_count"], name: "index_actb_questions_on_messages_count"
    t.index ["source_about_id"], name: "index_actb_questions_on_source_about_id"
    t.index ["time_limit_sec"], name: "index_actb_questions_on_time_limit_sec"
    t.index ["turn_max"], name: "index_actb_questions_on_turn_max"
    t.index ["user_id"], name: "index_actb_questions_on_user_id"
  end

  create_table "actb_room_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "room_id", null: false, comment: "対戦部屋"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.integer "position", null: false, comment: "順序"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_room_memberships_on_position"
    t.index ["room_id", "user_id"], name: "index_actb_room_memberships_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_actb_room_memberships_on_room_id"
    t.index ["user_id"], name: "index_actb_room_memberships_on_user_id"
  end

  create_table "actb_room_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "room_id", null: false, comment: "対戦部屋"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_actb_room_messages_on_room_id"
    t.index ["user_id"], name: "index_actb_room_messages_on_user_id"
  end

  create_table "actb_rooms", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "begin_at", null: false, comment: "対戦開始日時"
    t.datetime "end_at", comment: "対戦終了日時"
    t.bigint "rule_id", null: false, comment: "ルール"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "battles_count", default: 0, null: false, comment: "連戦数"
    t.boolean "practice", comment: "練習バトル？"
    t.bigint "bot_user_id", comment: "練習相手"
    t.index ["battles_count"], name: "index_actb_rooms_on_battles_count"
    t.index ["begin_at"], name: "index_actb_rooms_on_begin_at"
    t.index ["bot_user_id"], name: "index_actb_rooms_on_bot_user_id"
    t.index ["end_at"], name: "index_actb_rooms_on_end_at"
    t.index ["rule_id"], name: "index_actb_rooms_on_rule_id"
  end

  create_table "actb_rules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_rules_on_position"
  end

  create_table "actb_season_xrecords", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "judge_id", null: false, comment: "直前の勝敗"
    t.bigint "final_id", null: false, comment: "直前の結果"
    t.integer "battle_count", null: false, comment: "対戦数"
    t.integer "win_count", null: false, comment: "勝ち数"
    t.integer "lose_count", null: false, comment: "負け数"
    t.float "win_rate", null: false, comment: "勝率"
    t.float "rating", null: false, comment: "レーティング"
    t.float "rating_diff", null: false, comment: "直近レーティング変化"
    t.float "rating_max", null: false, comment: "レーティング(最大)"
    t.integer "straight_win_count", null: false, comment: "連勝数"
    t.integer "straight_lose_count", null: false, comment: "連敗数"
    t.integer "straight_win_max", null: false, comment: "連勝数(最大)"
    t.integer "straight_lose_max", null: false, comment: "連敗数(最大)"
    t.bigint "skill_id", null: false, comment: "ウデマエ"
    t.float "skill_point", null: false, comment: "ウデマエの内部ポイント"
    t.float "skill_last_diff", null: false, comment: "直近ウデマエ変化度"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disconnect_count", null: false, comment: "切断数"
    t.datetime "disconnected_at", comment: "最終切断日時"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "season_id", null: false, comment: "期"
    t.integer "create_count", null: false, comment: "users.actb_season_xrecord.create_count は users.actb_season_xrecords.count と一致"
    t.integer "generation", null: false, comment: "世代(seasons.generationと一致)"
    t.index ["battle_count"], name: "index_actb_season_xrecords_on_battle_count"
    t.index ["create_count"], name: "index_actb_season_xrecords_on_create_count"
    t.index ["disconnect_count"], name: "index_actb_season_xrecords_on_disconnect_count"
    t.index ["final_id"], name: "index_actb_season_xrecords_on_final_id"
    t.index ["generation"], name: "index_actb_season_xrecords_on_generation"
    t.index ["judge_id"], name: "index_actb_season_xrecords_on_judge_id"
    t.index ["lose_count"], name: "index_actb_season_xrecords_on_lose_count"
    t.index ["rating"], name: "index_actb_season_xrecords_on_rating"
    t.index ["rating_diff"], name: "index_actb_season_xrecords_on_rating_diff"
    t.index ["rating_max"], name: "index_actb_season_xrecords_on_rating_max"
    t.index ["season_id"], name: "index_actb_season_xrecords_on_season_id"
    t.index ["skill_id"], name: "index_actb_season_xrecords_on_skill_id"
    t.index ["straight_lose_count"], name: "index_actb_season_xrecords_on_straight_lose_count"
    t.index ["straight_lose_max"], name: "index_actb_season_xrecords_on_straight_lose_max"
    t.index ["straight_win_count"], name: "index_actb_season_xrecords_on_straight_win_count"
    t.index ["straight_win_max"], name: "index_actb_season_xrecords_on_straight_win_max"
    t.index ["user_id", "season_id"], name: "index_actb_season_xrecords_on_user_id_and_season_id", unique: true
    t.index ["user_id"], name: "index_actb_season_xrecords_on_user_id"
    t.index ["win_count"], name: "index_actb_season_xrecords_on_win_count"
    t.index ["win_rate"], name: "index_actb_season_xrecords_on_win_rate"
  end

  create_table "actb_seasons", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false, comment: "レーティング"
    t.integer "generation", null: false, comment: "世代"
    t.datetime "begin_at", null: false, comment: "期間開始日時"
    t.datetime "end_at", null: false, comment: "期間終了日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["begin_at"], name: "index_actb_seasons_on_begin_at"
    t.index ["end_at"], name: "index_actb_seasons_on_end_at"
    t.index ["generation"], name: "index_actb_seasons_on_generation"
  end

  create_table "actb_settings", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "rule_id", null: false, comment: "選択ルール"
    t.string "session_lock_token", comment: "複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rule_id"], name: "index_actb_settings_on_rule_id"
    t.index ["user_id"], name: "index_actb_settings_on_user_id"
  end

  create_table "actb_skills", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_skills_on_position"
  end

  create_table "actb_source_abouts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_actb_source_abouts_on_position"
  end

  create_table "actb_vs_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対戦"
    t.string "sfen_body", limit: 1536, null: false, comment: "棋譜"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id"], name: "index_actb_vs_records_on_battle_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alert_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "subject", null: false
    t.string "body", limit: 8192, null: false
    t.datetime "created_at", null: false
  end

  create_table "auth_infos", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "provider", null: false, comment: "何経由でログインしたか"
    t.string "uid", null: false, comment: "長い内部ID(providerとペアではユニーク)"
    t.text "meta_info", comment: "とれた情報をハッシュで持っとく用"
    t.index ["provider", "uid"], name: "index_auth_infos_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_auth_infos_on_user_id"
  end

  create_table "cpu_battle_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", comment: "ログインしているならそのユーザー"
    t.string "judge_key", null: false, comment: "結果"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_key"], name: "index_cpu_battle_records_on_judge_key"
    t.index ["user_id"], name: "index_cpu_battle_records_on_user_id"
  end

  create_table "emox_bad_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_emox_bad_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_emox_bad_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_emox_bad_marks_on_user_id"
  end

  create_table "emox_battle_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対戦"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "judge_id", null: false, comment: "勝敗"
    t.integer "position", null: false, comment: "順序"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id", "user_id"], name: "index_emox_battle_memberships_on_battle_id_and_user_id", unique: true
    t.index ["battle_id"], name: "index_emox_battle_memberships_on_battle_id"
    t.index ["judge_id"], name: "index_emox_battle_memberships_on_judge_id"
    t.index ["position"], name: "index_emox_battle_memberships_on_position"
    t.index ["user_id"], name: "index_emox_battle_memberships_on_user_id"
  end

  create_table "emox_battles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "room_id", null: false, comment: "部屋"
    t.bigint "parent_id", comment: "親"
    t.bigint "rule_id", null: false, comment: "ルール"
    t.bigint "final_id", null: false, comment: "結果"
    t.datetime "begin_at", null: false, comment: "対戦開始日時"
    t.datetime "end_at", comment: "対戦終了日時"
    t.integer "battle_pos", null: false, comment: "連戦インデックス"
    t.boolean "practice", comment: "練習バトル？"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_pos"], name: "index_emox_battles_on_battle_pos"
    t.index ["begin_at"], name: "index_emox_battles_on_begin_at"
    t.index ["end_at"], name: "index_emox_battles_on_end_at"
    t.index ["final_id"], name: "index_emox_battles_on_final_id"
    t.index ["parent_id"], name: "index_emox_battles_on_parent_id"
    t.index ["room_id"], name: "index_emox_battles_on_room_id"
    t.index ["rule_id"], name: "index_emox_battles_on_rule_id"
  end

  create_table "emox_clip_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_emox_clip_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_emox_clip_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_emox_clip_marks_on_user_id"
  end

  create_table "emox_emotion_folders", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_emotion_folders_on_position"
  end

  create_table "emox_emotions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "所有者"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "name", null: false, comment: "トリガー名"
    t.string "message", null: false, comment: "表示用伝言"
    t.string "voice", null: false, comment: "発声用文言"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_emox_emotions_on_folder_id"
    t.index ["position"], name: "index_emox_emotions_on_position"
    t.index ["user_id"], name: "index_emox_emotions_on_user_id"
  end

  create_table "emox_finals", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_finals_on_position"
  end

  create_table "emox_folders", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false, comment: "for STI"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "user_id"], name: "index_emox_folders_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_emox_folders_on_user_id"
  end

  create_table "emox_good_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_emox_good_marks_on_question_id"
    t.index ["user_id", "question_id"], name: "index_emox_good_marks_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_emox_good_marks_on_user_id"
  end

  create_table "emox_histories", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "question_id", null: false, comment: "出題"
    t.bigint "room_id", comment: "対戦部屋"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ox_mark_id", null: false, comment: "解答"
    t.index ["ox_mark_id"], name: "index_emox_histories_on_ox_mark_id"
    t.index ["question_id"], name: "index_emox_histories_on_question_id"
    t.index ["room_id"], name: "index_emox_histories_on_room_id"
    t.index ["user_id"], name: "index_emox_histories_on_user_id"
  end

  create_table "emox_judges", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_judges_on_position"
  end

  create_table "emox_lineages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_lineages_on_position"
  end

  create_table "emox_lobby_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_emox_lobby_messages_on_user_id"
  end

  create_table "emox_main_xrecords", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "judge_id", null: false, comment: "直前の勝敗"
    t.bigint "final_id", null: false, comment: "直前の結果"
    t.integer "battle_count", null: false, comment: "対戦数"
    t.integer "win_count", null: false, comment: "勝ち数"
    t.integer "lose_count", null: false, comment: "負け数"
    t.float "win_rate", null: false, comment: "勝率"
    t.float "rating", null: false, comment: "レーティング"
    t.float "rating_diff", null: false, comment: "直近レーティング変化"
    t.float "rating_max", null: false, comment: "レーティング(最大)"
    t.integer "straight_win_count", null: false, comment: "連勝数"
    t.integer "straight_lose_count", null: false, comment: "連敗数"
    t.integer "straight_win_max", null: false, comment: "連勝数(最大)"
    t.integer "straight_lose_max", null: false, comment: "連敗数(最大)"
    t.bigint "skill_id", null: false, comment: "ウデマエ"
    t.float "skill_point", null: false, comment: "ウデマエの内部ポイント"
    t.float "skill_last_diff", null: false, comment: "直近ウデマエ変化度"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disconnect_count", null: false, comment: "切断数"
    t.datetime "disconnected_at", comment: "最終切断日時"
    t.index ["battle_count"], name: "index_emox_main_xrecords_on_battle_count"
    t.index ["disconnect_count"], name: "index_emox_main_xrecords_on_disconnect_count"
    t.index ["final_id"], name: "index_emox_main_xrecords_on_final_id"
    t.index ["judge_id"], name: "index_emox_main_xrecords_on_judge_id"
    t.index ["lose_count"], name: "index_emox_main_xrecords_on_lose_count"
    t.index ["rating"], name: "index_emox_main_xrecords_on_rating"
    t.index ["rating_diff"], name: "index_emox_main_xrecords_on_rating_diff"
    t.index ["rating_max"], name: "index_emox_main_xrecords_on_rating_max"
    t.index ["skill_id"], name: "index_emox_main_xrecords_on_skill_id"
    t.index ["straight_lose_count"], name: "index_emox_main_xrecords_on_straight_lose_count"
    t.index ["straight_lose_max"], name: "index_emox_main_xrecords_on_straight_lose_max"
    t.index ["straight_win_count"], name: "index_emox_main_xrecords_on_straight_win_count"
    t.index ["straight_win_max"], name: "index_emox_main_xrecords_on_straight_win_max"
    t.index ["user_id"], name: "index_emox_main_xrecords_on_user_id", unique: true
    t.index ["win_count"], name: "index_emox_main_xrecords_on_win_count"
    t.index ["win_rate"], name: "index_emox_main_xrecords_on_win_rate"
  end

  create_table "emox_moves_answers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_id", null: false, comment: "問題"
    t.integer "moves_count", null: false, comment: "N手"
    t.string "moves_str", null: false, comment: "連続した指し手"
    t.string "end_sfen", comment: "最後の局面"
    t.string "moves_human_str", comment: "人間向け指し手"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["moves_count"], name: "index_emox_moves_answers_on_moves_count"
    t.index ["question_id"], name: "index_emox_moves_answers_on_question_id"
  end

  create_table "emox_notifications", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_message_id", null: false, comment: "問題コメント"
    t.bigint "user_id", null: false, comment: "通知先"
    t.datetime "opened_at", comment: "開封日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_message_id"], name: "index_emox_notifications_on_question_message_id"
    t.index ["user_id"], name: "index_emox_notifications_on_user_id"
  end

  create_table "emox_ox_marks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false, comment: "正解・不正解"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_emox_ox_marks_on_key"
    t.index ["position"], name: "index_emox_ox_marks_on_position"
  end

  create_table "emox_ox_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "question_id", null: false, comment: "問題"
    t.integer "o_count", null: false, comment: "正解数"
    t.integer "x_count", null: false, comment: "不正解数"
    t.integer "ox_total", null: false, comment: "出題数"
    t.float "o_rate", comment: "高評価率"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["o_count"], name: "index_emox_ox_records_on_o_count"
    t.index ["o_rate"], name: "index_emox_ox_records_on_o_rate"
    t.index ["ox_total"], name: "index_emox_ox_records_on_ox_total"
    t.index ["question_id"], name: "index_emox_ox_records_on_question_id", unique: true
    t.index ["x_count"], name: "index_emox_ox_records_on_x_count"
  end

  create_table "emox_question_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "発言者"
    t.bigint "question_id", null: false, comment: "問題"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_emox_question_messages_on_question_id"
    t.index ["user_id"], name: "index_emox_question_messages_on_user_id"
  end

  create_table "emox_questions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.bigint "lineage_id", null: false, comment: "種類"
    t.string "init_sfen", null: false, comment: "問題"
    t.integer "time_limit_sec", comment: "制限時間(秒)"
    t.integer "difficulty_level", comment: "難易度"
    t.string "title", comment: "タイトル"
    t.string "description", limit: 512, comment: "説明"
    t.string "hint_desc", comment: "ヒント"
    t.string "source_author", comment: "作者"
    t.string "source_media_name", comment: "出典メディア"
    t.string "source_media_url", comment: "出典URL"
    t.date "source_published_on", comment: "出典年月日"
    t.bigint "source_about_id", comment: "所在"
    t.integer "turn_max", comment: "最大手数"
    t.boolean "mate_skip", comment: "詰みチェックをスキップする"
    t.string "direction_message", comment: "メッセージ"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "good_rate", comment: "高評価率"
    t.integer "moves_answers_count", default: 0, null: false, comment: "解答数"
    t.integer "histories_count", default: 0, null: false, comment: "履歴数(出題数とは異なる)"
    t.integer "good_marks_count", default: 0, null: false, comment: "高評価数"
    t.integer "bad_marks_count", default: 0, null: false, comment: "低評価数"
    t.integer "clip_marks_count", default: 0, null: false, comment: "保存された数"
    t.integer "messages_count", default: 0, null: false, comment: "コメント数"
    t.index ["bad_marks_count"], name: "index_emox_questions_on_bad_marks_count"
    t.index ["clip_marks_count"], name: "index_emox_questions_on_clip_marks_count"
    t.index ["difficulty_level"], name: "index_emox_questions_on_difficulty_level"
    t.index ["folder_id"], name: "index_emox_questions_on_folder_id"
    t.index ["good_marks_count"], name: "index_emox_questions_on_good_marks_count"
    t.index ["good_rate"], name: "index_emox_questions_on_good_rate"
    t.index ["histories_count"], name: "index_emox_questions_on_histories_count"
    t.index ["init_sfen"], name: "index_emox_questions_on_init_sfen"
    t.index ["key"], name: "index_emox_questions_on_key"
    t.index ["lineage_id"], name: "index_emox_questions_on_lineage_id"
    t.index ["messages_count"], name: "index_emox_questions_on_messages_count"
    t.index ["source_about_id"], name: "index_emox_questions_on_source_about_id"
    t.index ["time_limit_sec"], name: "index_emox_questions_on_time_limit_sec"
    t.index ["turn_max"], name: "index_emox_questions_on_turn_max"
    t.index ["user_id"], name: "index_emox_questions_on_user_id"
  end

  create_table "emox_room_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "room_id", null: false, comment: "対戦部屋"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.integer "position", null: false, comment: "順序"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_room_memberships_on_position"
    t.index ["room_id", "user_id"], name: "index_emox_room_memberships_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_emox_room_memberships_on_room_id"
    t.index ["user_id"], name: "index_emox_room_memberships_on_user_id"
  end

  create_table "emox_room_messages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "room_id", null: false, comment: "対戦部屋"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_emox_room_messages_on_room_id"
    t.index ["user_id"], name: "index_emox_room_messages_on_user_id"
  end

  create_table "emox_rooms", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "begin_at", null: false, comment: "対戦開始日時"
    t.datetime "end_at", comment: "対戦終了日時"
    t.bigint "rule_id", null: false, comment: "ルール"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "battles_count", default: 0, null: false, comment: "連戦数"
    t.boolean "practice", comment: "練習バトル？"
    t.bigint "bot_user_id", comment: "練習相手"
    t.index ["battles_count"], name: "index_emox_rooms_on_battles_count"
    t.index ["begin_at"], name: "index_emox_rooms_on_begin_at"
    t.index ["bot_user_id"], name: "index_emox_rooms_on_bot_user_id"
    t.index ["end_at"], name: "index_emox_rooms_on_end_at"
    t.index ["rule_id"], name: "index_emox_rooms_on_rule_id"
  end

  create_table "emox_rules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_rules_on_position"
  end

  create_table "emox_season_xrecords", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "judge_id", null: false, comment: "直前の勝敗"
    t.bigint "final_id", null: false, comment: "直前の結果"
    t.integer "battle_count", null: false, comment: "対戦数"
    t.integer "win_count", null: false, comment: "勝ち数"
    t.integer "lose_count", null: false, comment: "負け数"
    t.float "win_rate", null: false, comment: "勝率"
    t.float "rating", null: false, comment: "レーティング"
    t.float "rating_diff", null: false, comment: "直近レーティング変化"
    t.float "rating_max", null: false, comment: "レーティング(最大)"
    t.integer "straight_win_count", null: false, comment: "連勝数"
    t.integer "straight_lose_count", null: false, comment: "連敗数"
    t.integer "straight_win_max", null: false, comment: "連勝数(最大)"
    t.integer "straight_lose_max", null: false, comment: "連敗数(最大)"
    t.bigint "skill_id", null: false, comment: "ウデマエ"
    t.float "skill_point", null: false, comment: "ウデマエの内部ポイント"
    t.float "skill_last_diff", null: false, comment: "直近ウデマエ変化度"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disconnect_count", null: false, comment: "切断数"
    t.datetime "disconnected_at", comment: "最終切断日時"
    t.bigint "user_id", null: false, comment: "対戦者"
    t.bigint "season_id", null: false, comment: "期"
    t.integer "create_count", null: false, comment: "users.emox_season_xrecord.create_count は users.emox_season_xrecords.count と一致"
    t.integer "generation", null: false, comment: "世代(seasons.generationと一致)"
    t.index ["battle_count"], name: "index_emox_season_xrecords_on_battle_count"
    t.index ["create_count"], name: "index_emox_season_xrecords_on_create_count"
    t.index ["disconnect_count"], name: "index_emox_season_xrecords_on_disconnect_count"
    t.index ["final_id"], name: "index_emox_season_xrecords_on_final_id"
    t.index ["generation"], name: "index_emox_season_xrecords_on_generation"
    t.index ["judge_id"], name: "index_emox_season_xrecords_on_judge_id"
    t.index ["lose_count"], name: "index_emox_season_xrecords_on_lose_count"
    t.index ["rating"], name: "index_emox_season_xrecords_on_rating"
    t.index ["rating_diff"], name: "index_emox_season_xrecords_on_rating_diff"
    t.index ["rating_max"], name: "index_emox_season_xrecords_on_rating_max"
    t.index ["season_id"], name: "index_emox_season_xrecords_on_season_id"
    t.index ["skill_id"], name: "index_emox_season_xrecords_on_skill_id"
    t.index ["straight_lose_count"], name: "index_emox_season_xrecords_on_straight_lose_count"
    t.index ["straight_lose_max"], name: "index_emox_season_xrecords_on_straight_lose_max"
    t.index ["straight_win_count"], name: "index_emox_season_xrecords_on_straight_win_count"
    t.index ["straight_win_max"], name: "index_emox_season_xrecords_on_straight_win_max"
    t.index ["user_id", "season_id"], name: "index_emox_season_xrecords_on_user_id_and_season_id", unique: true
    t.index ["user_id"], name: "index_emox_season_xrecords_on_user_id"
    t.index ["win_count"], name: "index_emox_season_xrecords_on_win_count"
    t.index ["win_rate"], name: "index_emox_season_xrecords_on_win_rate"
  end

  create_table "emox_seasons", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false, comment: "レーティング"
    t.integer "generation", null: false, comment: "世代"
    t.datetime "begin_at", null: false, comment: "期間開始日時"
    t.datetime "end_at", null: false, comment: "期間終了日時"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["begin_at"], name: "index_emox_seasons_on_begin_at"
    t.index ["end_at"], name: "index_emox_seasons_on_end_at"
    t.index ["generation"], name: "index_emox_seasons_on_generation"
  end

  create_table "emox_settings", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "自分"
    t.bigint "rule_id", null: false, comment: "選択ルール"
    t.string "session_lock_token", comment: "複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rule_id"], name: "index_emox_settings_on_rule_id"
    t.index ["user_id"], name: "index_emox_settings_on_user_id"
  end

  create_table "emox_skills", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_skills_on_position"
  end

  create_table "emox_source_abouts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_emox_source_abouts_on_position"
  end

  create_table "emox_vs_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対戦"
    t.string "sfen_body", limit: 1536, null: false, comment: "棋譜"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id"], name: "index_emox_vs_records_on_battle_id"
  end

  create_table "free_battles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false, collation: "utf8_bin", comment: "URL識別子"
    t.string "kifu_url", comment: "入力した棋譜URL"
    t.string "title"
    t.text "kifu_body", size: :medium, null: false, comment: "棋譜本文"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.string "use_key", null: false
    t.datetime "accessed_at", null: false, comment: "最終参照日時"
    t.bigint "user_id"
    t.string "preset_key", null: false
    t.text "description", null: false
    t.string "sfen_body", limit: 8192, null: false
    t.string "sfen_hash", null: false
    t.integer "start_turn", comment: "???"
    t.integer "critical_turn", comment: "開戦"
    t.integer "outbreak_turn", comment: "中盤"
    t.integer "image_turn", comment: "???"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battled_at"], name: "index_free_battles_on_battled_at"
    t.index ["critical_turn"], name: "index_free_battles_on_critical_turn"
    t.index ["key"], name: "index_free_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_free_battles_on_outbreak_turn"
    t.index ["preset_key"], name: "index_free_battles_on_preset_key"
    t.index ["start_turn"], name: "index_free_battles_on_start_turn"
    t.index ["turn_max"], name: "index_free_battles_on_turn_max"
    t.index ["use_key"], name: "index_free_battles_on_use_key"
    t.index ["user_id"], name: "index_free_battles_on_user_id"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "description", limit: 512, null: false, comment: "自己紹介"
    t.string "twitter_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "swars_battles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false, comment: "対局識別子"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.string "rule_key", null: false, comment: "ルール"
    t.text "csa_seq", null: false, comment: "棋譜の断片"
    t.string "final_key", null: false, comment: "結果詳細"
    t.bigint "win_user_id", comment: "勝者(ショートカット用)"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.datetime "accessed_at", null: false, comment: "最終参照日時"
    t.string "preset_key", null: false
    t.string "sfen_body", limit: 8192, null: false
    t.string "sfen_hash", null: false
    t.integer "start_turn", comment: "???"
    t.integer "critical_turn", comment: "開戦"
    t.integer "outbreak_turn", comment: "中盤"
    t.integer "image_turn", comment: "???"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battled_at"], name: "index_swars_battles_on_battled_at"
    t.index ["critical_turn"], name: "index_swars_battles_on_critical_turn"
    t.index ["final_key"], name: "index_swars_battles_on_final_key"
    t.index ["key"], name: "index_swars_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_swars_battles_on_outbreak_turn"
    t.index ["preset_key"], name: "index_swars_battles_on_preset_key"
    t.index ["rule_key"], name: "index_swars_battles_on_rule_key"
    t.index ["start_turn"], name: "index_swars_battles_on_start_turn"
    t.index ["turn_max"], name: "index_swars_battles_on_turn_max"
    t.index ["win_user_id"], name: "index_swars_battles_on_win_user_id"
  end

  create_table "swars_crawl_reservations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "登録者"
    t.string "target_user_key", null: false, comment: "対象者"
    t.string "to_email", null: false, comment: "完了通知先メールアドレス"
    t.string "attachment_mode", null: false, comment: "ZIPファイル添付の有無"
    t.datetime "processed_at", comment: "処理完了日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_mode"], name: "index_swars_crawl_reservations_on_attachment_mode"
    t.index ["user_id"], name: "index_swars_crawl_reservations_on_user_id"
  end

  create_table "swars_grades", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "priority", null: false, comment: "優劣"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_swars_grades_on_key", unique: true
    t.index ["priority"], name: "index_swars_grades_on_priority"
  end

  create_table "swars_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対局"
    t.bigint "user_id", null: false, comment: "対局者"
    t.bigint "op_user_id", comment: "相手"
    t.bigint "grade_id", null: false, comment: "対局時の段級"
    t.string "judge_key", null: false, comment: "勝・敗・引き分け"
    t.string "location_key", null: false, comment: "▲△"
    t.integer "position", comment: "手番の順序"
    t.integer "grade_diff", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "think_all_avg", comment: "指し手の平均秒数(全体)"
    t.integer "think_end_avg", comment: "指し手の平均秒数(最後5手)"
    t.integer "two_serial_max", comment: "2秒の指し手が連続した回数"
    t.integer "think_last", comment: "最後の指し手の秒数"
    t.integer "think_max", comment: "最大考慮秒数"
    t.index ["battle_id", "location_key"], name: "memberships_sbri_lk", unique: true
    t.index ["battle_id", "op_user_id"], name: "memberships_bid_ouid", unique: true
    t.index ["battle_id", "user_id"], name: "memberships_sbri_sbui", unique: true
    t.index ["battle_id"], name: "index_swars_memberships_on_battle_id"
    t.index ["grade_id"], name: "index_swars_memberships_on_grade_id"
    t.index ["judge_key"], name: "index_swars_memberships_on_judge_key"
    t.index ["location_key"], name: "index_swars_memberships_on_location_key"
    t.index ["op_user_id"], name: "index_swars_memberships_on_op_user_id"
    t.index ["position"], name: "index_swars_memberships_on_position"
    t.index ["user_id"], name: "index_swars_memberships_on_user_id"
  end

  create_table "swars_search_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "プレイヤー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_swars_search_logs_on_user_id"
  end

  create_table "swars_users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "user_key", null: false, comment: "対局者名"
    t.bigint "grade_id", null: false, comment: "最高段級"
    t.datetime "last_reception_at", comment: "受容日時"
    t.integer "search_logs_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_swars_users_on_grade_id"
    t.index ["last_reception_at"], name: "index_swars_users_on_last_reception_at"
    t.index ["updated_at"], name: "index_swars_users_on_updated_at"
    t.index ["user_key"], name: "index_swars_users_on_user_key", unique: true
  end

  create_table "swars_zip_dl_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "登録者"
    t.bigint "swars_user_id", null: false, comment: "対象者"
    t.string "query", null: false, comment: "クエリ全体(予備)"
    t.integer "dl_count", null: false, comment: "ダウンロード数(記録用)"
    t.datetime "begin_at", null: false, comment: "スコープ(開始・記録用)"
    t.datetime "end_at", null: false, comment: "スコープ(終了)"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["end_at"], name: "index_swars_zip_dl_logs_on_end_at"
    t.index ["swars_user_id"], name: "index_swars_zip_dl_logs_on_swars_user_id"
    t.index ["user_id"], name: "index_swars_zip_dl_logs_on_user_id"
  end

  create_table "taggings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "ts_master_questions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "sfen", null: false
    t.integer "mate", null: false
    t.integer "position", null: false
    t.index ["mate", "position"], name: "index_ts_master_questions_on_mate_and_position", unique: true
    t.index ["mate"], name: "index_ts_master_questions_on_mate"
    t.index ["position"], name: "index_ts_master_questions_on_position"
  end

  create_table "ts_master_rules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_ts_master_rules_on_position"
  end

  create_table "ts_master_time_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.string "entry_name", null: false
    t.string "summary"
    t.bigint "rule_id", null: false
    t.integer "x_count", null: false
    t.float "spent_sec", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_name"], name: "index_ts_master_time_records_on_entry_name"
    t.index ["rule_id"], name: "index_ts_master_time_records_on_rule_id"
    t.index ["user_id"], name: "index_ts_master_time_records_on_user_id"
  end

  create_table "tsl_leagues", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "generation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["generation"], name: "index_tsl_leagues_on_generation"
  end

  create_table "tsl_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "user_id", null: false
    t.string "result_key", null: false, comment: "結果"
    t.integer "start_pos", null: false, comment: "初期順位"
    t.integer "age"
    t.integer "win"
    t.integer "lose"
    t.string "ox", null: false
    t.integer "previous_runner_up_count", null: false, comment: "これまでの次点回数"
    t.integer "seat_count", null: false, comment: "これまでの在籍数"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["league_id", "user_id"], name: "index_tsl_memberships_on_league_id_and_user_id", unique: true
    t.index ["league_id"], name: "index_tsl_memberships_on_league_id"
    t.index ["lose"], name: "index_tsl_memberships_on_lose"
    t.index ["previous_runner_up_count"], name: "index_tsl_memberships_on_previous_runner_up_count"
    t.index ["result_key"], name: "index_tsl_memberships_on_result_key"
    t.index ["start_pos"], name: "index_tsl_memberships_on_start_pos"
    t.index ["user_id"], name: "index_tsl_memberships_on_user_id"
    t.index ["win"], name: "index_tsl_memberships_on_win"
  end

  create_table "tsl_users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.integer "first_age", comment: "リーグ入り年齢"
    t.integer "last_age", comment: "リーグ最後の年齢"
    t.integer "memberships_count", default: 0
    t.integer "runner_up_count", null: false, comment: "次点個数"
    t.integer "level_up_generation", comment: "プロになった世代"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["level_up_generation"], name: "index_tsl_users_on_level_up_generation"
    t.index ["name"], name: "index_tsl_users_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false, comment: "キー"
    t.string "name", null: false, comment: "名前"
    t.string "user_agent", null: false, comment: "ブラウザ情報"
    t.string "race_key", null: false, comment: "種族"
    t.datetime "name_input_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["key"], name: "index_users_on_key", unique: true
    t.index ["race_key"], name: "index_users_on_race_key"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "xy_master_rules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_xy_master_rules_on_position"
  end

  create_table "xy_master_time_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "rule_id", null: false, comment: "ルール"
    t.string "entry_name", null: false
    t.string "summary"
    t.integer "x_count", null: false
    t.float "spent_sec", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_name"], name: "index_xy_master_time_records_on_entry_name"
    t.index ["rule_id"], name: "index_xy_master_time_records_on_rule_id"
    t.index ["user_id"], name: "index_xy_master_time_records_on_user_id"
  end

  add_foreign_key "actb_bad_marks", "actb_questions", column: "question_id"
  add_foreign_key "actb_bad_marks", "users"
  add_foreign_key "actb_battle_memberships", "actb_battles", column: "battle_id"
  add_foreign_key "actb_battle_memberships", "actb_judges", column: "judge_id"
  add_foreign_key "actb_battle_memberships", "users"
  add_foreign_key "actb_battles", "actb_battles", column: "parent_id"
  add_foreign_key "actb_battles", "actb_finals", column: "final_id"
  add_foreign_key "actb_battles", "actb_rooms", column: "room_id"
  add_foreign_key "actb_battles", "actb_rules", column: "rule_id"
  add_foreign_key "actb_clip_marks", "actb_questions", column: "question_id"
  add_foreign_key "actb_clip_marks", "users"
  add_foreign_key "actb_emotions", "actb_emotion_folders", column: "folder_id"
  add_foreign_key "actb_emotions", "users"
  add_foreign_key "actb_folders", "users"
  add_foreign_key "actb_good_marks", "actb_questions", column: "question_id"
  add_foreign_key "actb_good_marks", "users"
  add_foreign_key "actb_histories", "actb_ox_marks", column: "ox_mark_id"
  add_foreign_key "actb_histories", "actb_questions", column: "question_id"
  add_foreign_key "actb_histories", "actb_rooms", column: "room_id"
  add_foreign_key "actb_histories", "users"
  add_foreign_key "actb_lobby_messages", "users"
  add_foreign_key "actb_main_xrecords", "actb_finals", column: "final_id"
  add_foreign_key "actb_main_xrecords", "actb_judges", column: "judge_id"
  add_foreign_key "actb_main_xrecords", "actb_skills", column: "skill_id"
  add_foreign_key "actb_main_xrecords", "users"
  add_foreign_key "actb_moves_answers", "actb_questions", column: "question_id"
  add_foreign_key "actb_notifications", "actb_question_messages", column: "question_message_id"
  add_foreign_key "actb_notifications", "users"
  add_foreign_key "actb_ox_records", "actb_questions", column: "question_id"
  add_foreign_key "actb_question_messages", "actb_questions", column: "question_id"
  add_foreign_key "actb_question_messages", "users"
  add_foreign_key "actb_questions", "actb_folders", column: "folder_id"
  add_foreign_key "actb_questions", "actb_lineages", column: "lineage_id"
  add_foreign_key "actb_questions", "actb_source_abouts", column: "source_about_id"
  add_foreign_key "actb_questions", "users"
  add_foreign_key "actb_room_memberships", "actb_rooms", column: "room_id"
  add_foreign_key "actb_room_memberships", "users"
  add_foreign_key "actb_room_messages", "actb_rooms", column: "room_id"
  add_foreign_key "actb_room_messages", "users"
  add_foreign_key "actb_rooms", "actb_rules", column: "rule_id"
  add_foreign_key "actb_rooms", "users", column: "bot_user_id"
  add_foreign_key "actb_season_xrecords", "actb_finals", column: "final_id"
  add_foreign_key "actb_season_xrecords", "actb_judges", column: "judge_id"
  add_foreign_key "actb_season_xrecords", "actb_seasons", column: "season_id"
  add_foreign_key "actb_season_xrecords", "actb_skills", column: "skill_id"
  add_foreign_key "actb_season_xrecords", "users"
  add_foreign_key "actb_settings", "actb_rules", column: "rule_id"
  add_foreign_key "actb_settings", "users"
  add_foreign_key "actb_vs_records", "actb_battles", column: "battle_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "emox_bad_marks", "emox_questions", column: "question_id"
  add_foreign_key "emox_bad_marks", "users"
  add_foreign_key "emox_battle_memberships", "emox_battles", column: "battle_id"
  add_foreign_key "emox_battle_memberships", "emox_judges", column: "judge_id"
  add_foreign_key "emox_battle_memberships", "users"
  add_foreign_key "emox_battles", "emox_battles", column: "parent_id"
  add_foreign_key "emox_battles", "emox_finals", column: "final_id"
  add_foreign_key "emox_battles", "emox_rooms", column: "room_id"
  add_foreign_key "emox_battles", "emox_rules", column: "rule_id"
  add_foreign_key "emox_clip_marks", "emox_questions", column: "question_id"
  add_foreign_key "emox_clip_marks", "users"
  add_foreign_key "emox_emotions", "emox_emotion_folders", column: "folder_id"
  add_foreign_key "emox_emotions", "users"
  add_foreign_key "emox_folders", "users"
  add_foreign_key "emox_good_marks", "emox_questions", column: "question_id"
  add_foreign_key "emox_good_marks", "users"
  add_foreign_key "emox_histories", "emox_ox_marks", column: "ox_mark_id"
  add_foreign_key "emox_histories", "emox_questions", column: "question_id"
  add_foreign_key "emox_histories", "emox_rooms", column: "room_id"
  add_foreign_key "emox_histories", "users"
  add_foreign_key "emox_lobby_messages", "users"
  add_foreign_key "emox_main_xrecords", "emox_finals", column: "final_id"
  add_foreign_key "emox_main_xrecords", "emox_judges", column: "judge_id"
  add_foreign_key "emox_main_xrecords", "emox_skills", column: "skill_id"
  add_foreign_key "emox_main_xrecords", "users"
  add_foreign_key "emox_moves_answers", "emox_questions", column: "question_id"
  add_foreign_key "emox_notifications", "emox_question_messages", column: "question_message_id"
  add_foreign_key "emox_notifications", "users"
  add_foreign_key "emox_ox_records", "emox_questions", column: "question_id"
  add_foreign_key "emox_question_messages", "emox_questions", column: "question_id"
  add_foreign_key "emox_question_messages", "users"
  add_foreign_key "emox_questions", "emox_folders", column: "folder_id"
  add_foreign_key "emox_questions", "emox_lineages", column: "lineage_id"
  add_foreign_key "emox_questions", "emox_source_abouts", column: "source_about_id"
  add_foreign_key "emox_questions", "users"
  add_foreign_key "emox_room_memberships", "emox_rooms", column: "room_id"
  add_foreign_key "emox_room_memberships", "users"
  add_foreign_key "emox_room_messages", "emox_rooms", column: "room_id"
  add_foreign_key "emox_room_messages", "users"
  add_foreign_key "emox_rooms", "emox_rules", column: "rule_id"
  add_foreign_key "emox_rooms", "users", column: "bot_user_id"
  add_foreign_key "emox_season_xrecords", "emox_finals", column: "final_id"
  add_foreign_key "emox_season_xrecords", "emox_judges", column: "judge_id"
  add_foreign_key "emox_season_xrecords", "emox_seasons", column: "season_id"
  add_foreign_key "emox_season_xrecords", "emox_skills", column: "skill_id"
  add_foreign_key "emox_season_xrecords", "users"
  add_foreign_key "emox_settings", "emox_rules", column: "rule_id"
  add_foreign_key "emox_settings", "users"
  add_foreign_key "emox_vs_records", "emox_battles", column: "battle_id"
  add_foreign_key "swars_crawl_reservations", "users"
  add_foreign_key "swars_zip_dl_logs", "swars_users"
  add_foreign_key "swars_zip_dl_logs", "users"
end
