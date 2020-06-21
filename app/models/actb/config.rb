module Actb
  Config = {
    :main_navbar_enable              => true,

    # -------------------------------------------------------------------------------- 共通
    :rating_display_p                => false, # 内部レーティングを表示する？
    :action_cable_debug              => true,  # ActionCable関連デバッグモード

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 1.5, # ○**カウンター
    :matching_pow_base               => 50,  # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,   # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10,  # ○秒たったらマッチングを諦める(nullなら無限)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :jibun_wo_hidari_p               => false, # 自分を左に表示
    :best_questions_limit            => 10,  # 準備する問題数でこれが尽きたら引き分け
    :b_score_max_for_win             => 5,   # ○問正解先取で勝ち
    :ox_status_line_take_n           => 8,   # 上の○×行は最新何個表示する？
    :readygo_mode_delay              => 2.2, # 「対戦開始！」の待ち
    :deden_mode_delay                => 0.8, # 「デデン」の待ち

    # シングルトンモード
    :otetsuki_enabled                => true, # 誤答すると相手が解答するまで解答ボタンを押せないようにする？
    :q2_time_limit_sec               => 5,    # 1手は○秒以内に操作しないとタイムアウトになる
    :thinking_time_sec               => 5*100,   # 解く時間 nil 以外ならそれに設定(productionならnilにすること)
    :turn_limit_lazy_count           => 4,    # 3手詰なら○手足した手数まで操作できる

    # -------------------------------------------------------------------------------- チャット
    :lobby_messages_window_height    => 12,   # ロビーでの表示行数
    :room_messages_window_height     => 10,   # 部屋での表示行数
    :question_messages_window_height => 5,    # 問題での表示行数(未使用)

    :room_message_drop_lines         => 20,   # 部屋での表示行数(データ)
    # -------------------------------------------------------------------------------- プロフィール編集画面
    :profile_save_and_return         => true, # プロフィール編集画面で「保存」と同時に戻るか？

    # -------------------------------------------------------------------------------- フッター
    :footer_hidden_function          => false, # スクロールで隠すか？

    # -------------------------------------------------------------------------------- 問題作成
    :hint_enable                     => false, # ヒントカラムを有効にする？
    :save_and_back_to_index          => true,  # 「保存」したら一覧に戻る？
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
        # :matching_pow_base            => 6,     # gap < 2**(○+カウンター) ならマッチングする
        :matching_interval_second     => 4,     # カウンターをインクリメントする間隔(秒)
        :thinking_time_sec            => nil,   # 解く時間 nil 以外ならそれに設定(productionならnilにすること)
        :room_messages_window_height  => 5,     # 部屋での表示行数
        :matching_forgo_second        => 60,    # ○秒たったらマッチングを諦める(nullなら無限)
        # :action_cable_debug           => false, # ActionCable関連デバッグモード
      })
  end

  if Rails.env.production?
    Config.update({
        :main_navbar_enable           => false, # リンクを表示する？
      })
  end
end
