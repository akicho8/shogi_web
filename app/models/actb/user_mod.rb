module Actb
  concern :UserMod do
    included do
      include UserMod::ClipMod
      include UserMod::VoteMod
      include UserMod::FolderMod

      # 対局
      has_many :actb_room_memberships, class_name: "Actb::RoomMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_rooms, class_name: "Actb::Room", through: :actb_room_memberships                       # 対局(複数)

      # 対局
      has_many :actb_battle_memberships, class_name: "Actb::BattleMembership", dependent: :restrict_with_exception # 対局時の情報(複数)
      has_many :actb_battles, class_name: "Actb::Battle", through: :actb_battle_memberships                       # 対局(複数)

      # このユーザーが作成した問題(複数)
      has_many :actb_questions, class_name: "Actb::Question", dependent: :destroy do
        def mock_type1
          create! do |e|
            e.init_sfen = "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Actb::Question.count.next}p 1"
            e.moves_answers.build(moves_str: "G*5b")
          end
        end
      end

      # このユーザーに出題した問題(複数)
      has_many :actb_histories, class_name: "Actb::History", dependent: :destroy
    end

    concerning :MessageMethods do
      included do
        with_options(dependent: :destroy) do |o|
          has_many :actb_room_messages, class_name: "Actb::RoomMessage"
          has_many :actb_lobby_messages, class_name: "Actb::LobbyMessage"
          has_many :actb_question_messages, class_name: "Actb::QuestionMessage"
        end
      end

      def lobby_speak(message_body, options = {})
        actb_lobby_messages.create!({body: message_body}.merge(options))
      end

      def room_speak(room, message_body, options = {})
        actb_room_messages.create!({room: room, body: message_body}.merge(options))
      end

      def question_speak(question, message_body, options = {})
        actb_question_messages.create!({question: question, body: message_body}.merge(options))
      end
    end

    concerning :MainXrecordMod do
      included do
        has_one :actb_main_xrecord, class_name: "Actb::MainXrecord", dependent: :destroy

        delegate :rating, :straight_win_count, :straight_win_max, :skill, :skill_key, :skill_point, to: :actb_main_xrecord

        after_create do
          create_actb_main_xrecord!
        end
      end

      def create_actb_main_xrecord_if_blank
        actb_main_xrecord || create_actb_main_xrecord!
      end

      # 両方に同じ処理を行う
      def both_xrecord_each
        [:actb_main_xrecord, :actb_latest_xrecord].each do |e|
          yield public_send(e)
        end
      end
    end

    concerning :SeasonXrecordMod do
      included do
        # プロフィール
        with_options(class_name: "Actb::SeasonXrecord", dependent: :destroy) do
          has_one :actb_season_xrecord, -> { newest_order }
          has_many :actb_season_xrecords
        end

        after_create do
          create_actb_season_xrecord_if_blank
        end
      end

      def create_actb_season_xrecord_if_blank
        actb_latest_xrecord
      end

      def create_actb_main_xrecord_if_blank
        actb_main_xrecord || create_actb_main_xrecord!
      end

      # 必ず存在する最新シーズンのプロフィール
      def actb_latest_xrecord
        actb_season_xrecords.find_or_create_by!(season: Season.newest)
      end
    end

    concerning :SettingMod do
      included do
        has_one :actb_setting, class_name: "Actb::Setting", dependent: :destroy

        after_create do
          create_actb_setting!
        end
      end

      def create_actb_setting_if_blank
        actb_setting || create_actb_setting!
      end
    end

    concerning :UserInfoMethods do
      def info
        out = ""

        out += {
          "名前"               => name,
          "レーティング"       => rating,
          "クラス"             => skill_key,
          "作成問題数"         => actb_questions.count,
          "最新シーズン情報ID" => actb_latest_xrecord.id,
          "永続的プロフ情報ID" => actb_main_xrecord.id,
          "部屋入室数"         => actb_room_memberships.count,
          "対局数"             => actb_battle_memberships.count,
          "問題履歴数"         => actb_histories.count,
          "バトル中発言数"     => actb_room_messages.count,
          "ロビー発言数"       => actb_lobby_messages.count,
          "問題コメント数"     => actb_question_messages.count,
        }.to_t

        out
      end
    end
  end
end
