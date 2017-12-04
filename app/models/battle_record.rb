# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味               | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |                  |       |
# | unique_key         | ユニークなハッシュ | string(255) | NOT NULL    |                  |       |
# | battle_key         | Battle key         | string(255) | NOT NULL    |                  |       |
# | battled_at         | Battled at         | datetime    | NOT NULL    |                  |       |
# | battle_group_key   | Battle group key   | string(255) | NOT NULL    |                  |       |
# | csa_seq            | Csa seq            | text(65535) | NOT NULL    |                  |       |
# | battle_result_key  | Battle result key  | string(255) | NOT NULL    |                  |       |
# | win_battle_user_id | Win battle user    | integer(8)  |             | => BattleUser#id | A     |
# | turn_max           | 手数               | integer(4)  |             |                  |       |
# | kifu_header        | 棋譜ヘッダー       | text(65535) |             |                  |       |
# | created_at         | 作成日時           | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |                  |       |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

class BattleRecord < ApplicationRecord
  has_one :battle_ship_black, -> { where(position: 0) }, class_name: "BattleShip"
  has_one :battle_ship_white, -> { where(position: 1) }, class_name: "BattleShip"

  has_one :battle_ship_win,  -> { where(win_flag: true) }, class_name: "BattleShip"
  has_one :battle_ship_lose, -> { where(win_flag: false) }, class_name: "BattleShip"

  has_many :battle_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle_record do
    def black
      first
    end

    def white
      second
    end
  end

  has_many :battle_users, through: :battle_ships do
    def black
      first
    end

    def white
      second
    end
  end

  belongs_to :win_battle_user, class_name: "BattleUser", optional: true

  before_validation do
    self.unique_key ||= SecureRandom.hex

    # "" から ten_min への変換
    if battle_group_key
      self.battle_group_key = BattleGroupInfo.fetch(battle_group_key).key
    end

    if battle_key
      self.battled_at ||= Time.zone.parse(battle_key.split("-").last)
    end
  end

  with_options presence: true do
    validates :unique_key
    validates :battle_key
    validates :battled_at
    validates :battle_group_key
    validates :battle_result_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  def to_param
    battle_key
  end

  def battle_group_info
    BattleGroupInfo.fetch(battle_group_key)
  end

  concerning :HenkanMethods do
    included do
      has_many :converted_infos, as: :convertable, dependent: :destroy

      serialize :kifu_header
      serialize :csa_seq

      before_validation do
        self.kifu_header ||= {}
        self.turn_max ||= 0
      end

      before_save do
        if changes[:csa_seq]
          if csa_seq
            if battle_ships.second # 最初のときは、まだ保存されていないレコード
              info = Bushido::Parser.parse(kifu_body)
              converted_infos.destroy_all
              KifuFormatInfo.each do |e|
                converted_infos.build(converted_body: info.public_send("to_#{e.key}"), converted_format: e.key)
              end
              self.turn_max = info.mediator.turn_max
              self.kifu_header = info.header
            end
          end
        end
      end
    end

    def kifu_body
      out = []
      out << "N+#{battle_ships.black.name_with_rank}"
      out << "N-#{battle_ships.white.name_with_rank}"
      out << "$START_TIME:#{battled_at.to_s(:csa_ymdhms)}"
      out << "$EVENT:将棋ウォーズ(#{battle_group_info.long_name})"
      out << "$TIME_LIMIT:#{battle_group_info.csa_time_limit}"
      # out << "$OPENING:不明"
      out << "+"

      nokori = [battle_group_info.life_time] * 2
      csa_seq.each.with_index { |(a, b), i|
        i = i.modulo(nokori.size)
        tsukatta = nokori[i] - b
        nokori[i] = b

        out << "#{a}"
        out << "T#{tsukatta}"
      }

      out << "%#{battle_result_info.csa_key}"
      out.join("\n") + "\n"
    end
  end

  concerning :HelperMethods do
    def reverse_user_ship(battle_user)
      battle_ships.find {|e| e.battle_user != battle_user } # FIXME: battle_ships 下にメソッドとする
    end

    def current_user_ship(battle_user)
      battle_ships.find {|e| e.battle_user == battle_user } # FIXME: battle_ships 下にメソッドとする
    end

    def winner_desuka?(battle_user)
      if win_battle_user
        win_battle_user == battle_user
      end
    end

    def lose_desuka?(battle_user)
      if win_battle_user
        win_battle_user != battle_user
      end
    end

    def kekka_emoji(battle_user)
      if winner_desuka?(battle_user)
        # # "&#x1f604;"
        # # "&#x1F4AE;"             # たいへんよくできました
        # "&#x1f601;"             # にっこり
        "○"
      else
        # "&#128552;"
        # "&#x274c;"              # 赤い×
        "●"
      end
    end
  end

  concerning :ImportMethods do
    class_methods do
      def battle_agent
        @battle_agent ||= BattleAgent.new
      end

      def import_all(**params)
        BattleGroupInfo.each do |e|
          import_one(params.merge(gtype: e.swars_real_key))
        end
      end

      def import_one(**params)
        list = battle_agent.history_get(params)
        list.each do |history|
          import_by_battle_key(history[:battle_key])
        end
      end

      def import_by_battle_key(battle_key)
        # 登録済みなのでスキップ
        if BattleRecord.where(battle_key: battle_key).exists?
          return
        end

        info = battle_agent.record_get(battle_key)

        # 対局中や引き分けのときは棋譜がないのでスキップ
        unless info[:battle_done]
          return
        end

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない (そもそも引き分けには棋譜がない)
        # unless info[:__battle_result_key].match?(/(SENTE|GOTE)_WIN/)
        #   next
        # end

        battle_users = info[:battle_user_infos].collect do |e|
          BattleUser.find_or_initialize_by(battle_user_key: e[:battle_user_key]).tap do |battle_user|
            battle_rank = BattleRank.find_by!(unique_key: e[:battle_rank])
            battle_user.update!(battle_rank: battle_rank) # 常にランクを更新する
          end
        end

        battle_record = BattleRecord.new
        battle_record.attributes = {
          battle_key: info[:battle_key],
          battle_group_key: info.dig(:gamedata, :gtype),
          csa_seq: info[:csa_seq],
        }

        if md = info[:__battle_result_key].match(/\A(?<prefix>\w+)_WIN_(?<battle_result_key>\w+)/)
          winner_index = md[:prefix] == "SENTE" ? 0 : 1
          battle_record.battle_result_key = md[:battle_result_key]
        else
          raise "must not happen"
          winner_index = nil
          battle_record.battle_result_key = info[:__battle_result_key]
        end

        info[:battle_user_infos].each.with_index do |e, i|
          battle_user = BattleUser.find_by!(battle_user_key: e[:battle_user_key])
          battle_rank = BattleRank.find_by!(unique_key: e[:battle_rank])
          battle_record.battle_ships.build(battle_user:  battle_user, battle_rank: battle_rank, win_flag: i == winner_index)
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、BattleRecord 自体に入れとく
        # いらんかったらあとでとる
        if winner_index
          battle_record.win_battle_user = battle_record.battle_ships[winner_index].battle_user
        end

        battle_record.save!
      end
    end

    def battle_result_info
      BattleResultInfo.fetch(battle_result_key)
    end
  end

  concerning :KaisekiMethoes do
    def kaiseki_kekka_hash(location)
      kishin_count = 5

      location = Bushido::Location[location]
      list = csa_seq.find_all.with_index { |e, i| i.modulo(2) == location.code }
      v1 = list.collect { |a, b| b }

      v2 = v1.chunk_while { |a, b| (a - b) <= 2 }.to_a              # => [[136], [121], [101], [28], [18, 17, 16, 15, 14, 12], [7, 136], [121], [101], [28], [18, 17, 16, 15, 14, 12, 11]]
      v3 = v2.collect(&:size)                                      # => [1, 1, 1, 1, 6, 2, 1, 1, 1, 7]
      v4 = v3.group_by(&:itself).transform_values(&:size)          # => {1=>7, 6=>1, 2=>1, 7=>1}
      v5 = v4.count { |k, v| k > kishin_count }                              # => 2
      v6 = v5 >= 1

      {
        v1: v1,
        v2: v2,
        v3: v3,
        v4: v4,
        v5: v5,
        v6: v6,
      }
    end

    def kishin_tsukatta?(user_ship)
      if battle_group_info.key == :ten_min || !Rails.env.production?
        kaiseki_kekka_hash(user_ship.position).values.last
      end
    end
  end
end
