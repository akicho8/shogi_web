module Actf
  concern :UserMod do
    included do
      # 対局
      has_many :actf_rooms, class_name: "Actf::Room", through: :memberships                           # 対局(複数)
      has_many :actf_memberships, class_name: "Actf::Membership", dependent: :restrict_with_exception # 対局時の情報(複数)

      # このユーザーが作成した問題(複数)
      has_many :actf_questions, class_name: "Actf::Question", dependent: :destroy

      # このユーザーに出題した問題(複数)
      has_many :actf_histories, class_name: "Actf::History", dependent: :destroy

      # チャット関連
      with_options(dependent: :destroy) do |o|
        has_many :actf_room_messages, class_name: "Actf::RoomMessage"
        has_many :actf_lobby_messages, class_name: "Actf::LobbyMessage"
      end

      # プロフィール
      has_one :actf_profile, class_name: "Actf::Profile", dependent: :destroy
      delegate :rating, :rensho_count, :rensho_max, to: :actf_profile
      after_create do
        actf_profile || create_actf_profile!
      end
    end
  end
end
