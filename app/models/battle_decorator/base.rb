module BattleDecorator
  class Base
    def self.personal_clock_format(value)
      m, s = value.divmod(1.minutes)
      if m == 0
        s
      else
        "#{m}:%02d" % s
      end
    end

    def self.default_params
      {
        outer_columns: 3,       # 横何列か
        cell_rows: 25,          # 縦何行か
        separator: "→",        # 戦型の区切り
        strategy_take_max: 3,   # 戦型は最大何個表示するか
      }
    end

    attr_accessor :params

    def initialize(params)
      @params = self.class.default_params.merge(params)
    end

    def hand_info(*args)
      if e = hand_log_for(*args)
        value = e.to_ki2(same_suffix: "\u3000", separator: " ", compact_if_gt: 7)

        if debug_mode?
          value = "９九成香左上"
          # value = "１２３４５６".chars.take(rand(4..6)).join
          # value = "１２３４５６"
        end

        {
          :object => e,
          :value  => value,
          :class  => "hand_size#{value.size}",
        }
      end
    end

    def player_name_for(location)
    end

    def end_at_s
    end

    def strategy_pack_for(location)
      if m = membership_for(location)
        sep = " #{params[:separator]} "
        max = 3
        s = nil
        s ||= m.attack_tag_list.take(max).join(sep).presence
        s ||= m.defense_tag_list.take(max).join(sep).presence
        s ||= m.note_tag_list.take(max).grep_v(/指導対局/).first.to_s.presence
        s ||= "不明"
        s = s.remove(/△|▲/)

        location = Bioshogi::Location.fetch(location)
        "#{location.hexagon_mark} #{s}"
      end
    end

    # location_kanji_char(:black) # => "先 ☗"
    def location_kanji_char(location)
      location = Bioshogi::Location.fetch(location)
      name = location.call_name(handicap?)
      name.chars.first
    end

    def battle_begin_at
      battle.battled_at
    end

    def battle_end_at
    end

    def begin_at_s
      if v = battle_begin_at
        v.to_s(:ja_ad_format)
      end
    end

    def end_at_s
      if v = battle_end_at
        v.to_s(:ja_ad_format)
      end
    end

    def datetime_blank
    end

    def grade_name_for(location)
    end

    def umpire_name
    end

    def desc_body
    end

    def preset_str
      preset_info.name
    end

    def hold_time_str
    end

    def total_seconds_str_for(location)
      location = Bioshogi::Location.fetch(location)
      seconds = total_seconds_for(location)
      m, s = seconds.divmod(1.minutes)
      [location.hexagon_mark, " ", m.nonzero? ? "#{m}分" : nil, "#{s}秒"].join
    end

    def tournament_name
    end

    def battle_result_str
    end

    def battle
      params[:battle]
    end

    def membership_for(location)
      location = Bioshogi::Location.fetch(location)
      memberships[location.code]
    end

    def inner_fixed_columns
      location_size
    end

    def outer_columns
      params[:outer_columns]
    end

    def cell_rows
      params[:cell_rows]
    end

    def page_count
      turn_max = battle.turn_max + one_if_handicap

      q, r = turn_max.divmod(count_of_1page)
      if r.nonzero?
        q += 1
      end

      # 初手投了の場合 q == 0 で何も表示されなくなるのを防ぐ
      if q.zero?
        q = 1
      end

      q
    end

    def rule_name
    end

    def as_json(*)
      {
        desc_body: desc_body,
        tournament_name: tournament_name,
        rule_name: rule_name,
        strategy_pack_for_black: strategy_pack_for(:black),
        strategy_pack_for_white: strategy_pack_for(:white),
        battle_result_str: battle_result_str,
        player_name_for_black: player_name_for(:black),
        player_name_for_white: player_name_for(:white),
        grade_name_for_black: grade_name_for(:black),
        grade_name_for_white: grade_name_for(:white),
        umpire_name: "",
        begin_at_s: begin_at_s,
        end_at_s: end_at_s,
      }
    end

    private

    def total_seconds_for(location)
    end

    def debug_mode?
      params[:formal_sheet_debug]
    end

    def hand_log_for(*args)
      if idx = index_of(*args)
        hand_logs[idx]
      end
    end

    def memberships
      []
    end

    def preset_info
      battle.preset_info
    end

    def handicap?
      preset_info.handicap
    end

    def win_membership
      @win_membership ||= memberships.find { |e| e.judge_info.key == :win }
    end

    def lose_membership
      @lose_membership ||= memberships.find { |e| e.judge_info.key == :lose }
    end

    def index_of(page_index, x, y, left_or_right)
      if handicap?
        if page_index == 0 && x == 0 && y == 0 && left_or_right == 0
          return
        end
      end

      base = page_index * count_of_1page
      offset = x * (cell_rows * location_size) + (y * inner_fixed_columns) + left_or_right
      base + offset - one_if_handicap
    end

    def one_if_handicap
      handicap? ? 1 : 0
    end

    def count_of_1page
      cell_rows * outer_columns * inner_fixed_columns
    end

    def hand_logs
      @hand_logs ||= heavy_parsed_info.mediator.hand_logs
    end

    def heavy_parsed_info
      battle.heavy_parsed_info
    end

    def location_size
      Bioshogi::Location.count
    end

    def vc
      params[:view_context]
    end
  end
end
