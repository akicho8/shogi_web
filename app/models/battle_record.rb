# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle key       | string(255) | NOT NULL    |                  | A     |
# | battled_at         | Battled at       | datetime    | NOT NULL    |                  |       |
# | battle_rule_key    | Battle rule key  | string(255) | NOT NULL    |                  | B     |
# | csa_seq            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle_state_key   | Battle state key | string(255) | NOT NULL    |                  | C     |
# | win_battle_user_id | Win battle user  | integer(8)  |             | => BattleUser#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | kifu_header        | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

class BattleRecord < ApplicationRecord
  has_one :battle_ship_black, -> { where(position: 0) }, class_name: "BattleShip"
  has_one :battle_ship_white, -> { where(position: 1) }, class_name: "BattleShip"

  has_one :battle_ship_win,  -> { where(win_lose_key: :win) }, class_name: "BattleShip"
  has_one :battle_ship_lose, -> { where(win_lose_key: :lose) }, class_name: "BattleShip"

  has_many :battle_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle_record do
    def black
      first
    end

    def white
      second
    end

    def win
      win_lose_key_eq(:win)
    end

    def lose
      win_lose_key_eq(:lose)
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
    # "" から ten_min への変換
    if battle_rule_key
      self.battle_rule_key = BattleRuleInfo.fetch(battle_rule_key).key
    end

    # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
    if battle_key
      self.battled_at ||= Time.zone.parse(battle_key.split("-").last)
    end
  end

  with_options presence: true do
    validates :battle_key
    validates :battled_at
    validates :battle_rule_key
    validates :battle_state_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  def to_param
    battle_key
  end

  def battle_rule_info
    BattleRuleInfo.fetch(battle_rule_key)
  end

  concerning :HenkanMethods do
    included do
      serialize :csa_seq

      before_validation do
      end

      before_save do
        if changes[:csa_seq]
          if csa_seq
            if battle_ships.white # 最初のときは、まだ保存されていないレコード
              parser_run
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
      out << "$EVENT:将棋ウォーズ(#{battle_rule_info.long_name})"
      out << "$TIME_LIMIT:#{battle_rule_info.csa_time_limit}"

      # $OPENING は 戦型 のことで、これが判明するのはパースの後なのでいまはわからない。
      # それに自動的にあとから埋められるのでここは指定しなくてよい
      # out << "$OPENING:不明"

      # 平手なので先手から
      out << "+"

      life_times = [battle_rule_info.life_time] * 2
      csa_seq.each.with_index { |(t1, t2), i|
        i = i.modulo(life_times.size)
        used = life_times[i] - t2
        life_times[i] = t2

        out << "#{t1}"
        out << "T#{used}"
      }

      out << "%#{battle_state_info.csa_key}"
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

    def win_lose_str(battle_user)
      if win_battle_user
        if winner_desuka?(battle_user)
          Fa.fa_i(:circle_o)
        else
          Fa.fa_i(:circle)
        end
      else
        Fa.fa_i(:minus, :class => "icon_hidden")
      end
    end
  end

  concerning :ImportMethods do
    class_methods do
      def battle_agent
        @battle_agent ||= BattleAgent.new
      end

      def import_all(**params)
        BattleRuleInfo.each do |e|
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

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない
        # # ここで DRAW_SENNICHI も弾く
        # unless info[:__battle_state_key].match?(/(SENTE|GOTE)_WIN/)
        #   return
        # end

        battle_users = info[:battle_user_infos].collect do |e|
          BattleUser.find_or_initialize_by(uid: e[:uid]).tap do |battle_user|
            battle_rank = BattleRank.find_by!(unique_key: e[:battle_rank])
            battle_user.update!(battle_rank: battle_rank) # 常にランクを更新する
          end
        end

        battle_record = BattleRecord.new({
            battle_key: info[:battle_key],
            battle_rule_key: info.dig(:gamedata, :gtype),
            csa_seq: info[:csa_seq],
          })

        if md = info[:__battle_state_key].match(/\A(?<prefix>\w+)_WIN_(?<battle_state_key>\w+)/)
          winner_index = md[:prefix] == "SENTE" ? 0 : 1
          battle_record.battle_state_key = md[:battle_state_key]
        else
          winner_index = nil
          battle_record.battle_state_key = info[:__battle_state_key]
        end

        info[:battle_user_infos].each.with_index do |e, i|
          battle_user = BattleUser.find_by!(uid: e[:uid])
          battle_rank = BattleRank.find_by!(unique_key: e[:battle_rank])

          if winner_index
            win_lose_key = (i == winner_index) ? :win : :lose
          else
            win_lose_key = :draw
          end

          battle_record.battle_ships.build(battle_user:  battle_user, battle_rank: battle_rank, win_lose_key: win_lose_key)
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、BattleRecord 自体に入れとく
        # いらんかったらあとでとる
        if winner_index
          battle_record.win_battle_user = battle_record.battle_ships[winner_index].battle_user
        end

        battle_record.save!
      end
    end

    def battle_state_info
      BattleStateInfo.fetch(battle_state_key)
    end
  end

  concerning :KaisekiMethoes do
    def kishin_analyze_result_hask(location)
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
      if battle_rule_info.key == :ten_min || !Rails.env.production?
        kishin_analyze_result_hask(user_ship.position).values.last
      end
    end
  end

  concerning :MountainMethods do
    included do
      has_many :converted_infos, as: :convertable, dependent: :destroy

      serialize :kifu_header

      before_validation do
        self.kifu_header ||= {}
        self.turn_max ||= 0
      end
    end

    def parser_run
      info = Bushido::Parser.parse(kifu_body, typical_error_case: :embed)
      converted_infos.destroy_all
      KifuFormatInfo.each do |e|
        converted_infos.build(text_body: info.public_send("to_#{e.key}"), text_format: e.key)
      end
      self.turn_max = info.mediator.turn_max
      self.kifu_header = info.header

      # BattleRecord.tagged_with(...) とするため。on をつけないと集約できる
      self.defense_tag_list = info.mediator.players.flat_map { |e| e.defense_infos }.collect(&:key)
      self.attack_tag_list = info.mediator.players.flat_map { |e| e.attack_infos }.collect(&:key)

      after_parser_run(info)
    end

    def after_parser_run(info)
      # 両者にタグを作らんと意味ないじゃん
      info.mediator.players.each.with_index do |player, i|
        battle_ship = battle_ships[i]
        battle_ship.defense_tag_list = player.defense_infos.collect(&:key)
        battle_ship.attack_tag_list = player.attack_infos.collect(&:key)
      end
    end

    def mountain_post_onece
      unless mountain_url
        mountain_post
      end
    end

    def mountain_post
      url = Rails.application.routes.url_helpers.mountain_upload_url
      kif = converted_infos.text_format_eq(:kif).take!.text_body

      if AppConfig[:run_localy]
        v = "http://shogi-s.com/result/5a274d10px"
      else
        response = Faraday.post(url, kif: kif)
        logger.info(response.status.to_t)
        logger.info(response.headers.to_t)
        v = response.headers["location"].presence
      end

      if v
        update!(mountain_url: v)
      end
    end
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
    end
  end
end
