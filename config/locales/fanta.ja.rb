{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        battle: {
        },
      },
    },
    activerecord: {
      models: {
        "fanta/battle": "対局",
        "fanta/user": "ユーザー",
        "fanta/membership": "対局と対局者の対応",
      },
      attributes: {
        "fanta/user": {
          :name                 => "名前",
          :avatar               => "アバター",
          :online_at            => "オンラインになった日時",
          :fighting_at          => "memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる",
          :matching_at          => "マッチング中(開始日時)",
          :lifetime_key         => "ルール・持ち時間",
          :platoon_key          => "ルール・人数",
          :self_preset_key      => "ルール・自分の手合割",
          :oppo_preset_key      => "ルール・相手の手合割",
          :robot_accept_key             => "CPUと対戦するかどうか",
          :user_agent           => "ブラウザ情報",
        },
        "fanta/profile": {
          :begin_greeting_message     => "対局開始時のあいさつ",
          :end_greeting_message    => "対局終了時のあいさつ",
        },

        "fanta/battle": {
          :black_preset_key     => "▲手合割",
          :white_preset_key     => "△手合割",
          :lifetime_key         => "時間",
          :platoon_key          => "人数",
          :full_sfen       => "USI形式棋譜",
          :clock_counts         => "対局時計情報",
          :countdown_flags  => "秒読み状態",
          :turn_max             => "手番数",
          :battle_request_at    => "対局申し込みによる成立日時",
          :auto_matched_at      => "自動マッチングによる成立日時",
          :begin_at             => "メンバーたち部屋に入って対局開始になった日時",
          :end_at               => "バトル終了日時",
          :last_action_key      => "最後の状態",
          :win_location_key     => "勝った方の先後",
          :memberships_count    => "対局者総数",
          :watch_ships_count    => "この部屋の観戦者数",
        },

        "fanta/membership": {
          :battle              => "部屋",
          :user                => "ユーザー",
          :preset_key          => "手合割",
          :location_key        => "先後",
          :position            => "入室順序",
          :standby_at          => "準備完了日時",
          :fighting_at         => "部屋に入った日時で抜けたり切断すると空",
          :time_up_at  => "タイムアップしたのを検知した日時",
        },

        "fanta/watch_ship": {
          :battle              => "部屋",
          :user                => "ユーザー",
        },

        "fanta/chat_message": {
          :battle              => "部屋",
          :user                => "ユーザー",
          :message             => "発言",
        },

        "fanta/lobby_message": {
          :user                => "ユーザー",
          :message             => "発言",
        },
      },
    },
  },
}
