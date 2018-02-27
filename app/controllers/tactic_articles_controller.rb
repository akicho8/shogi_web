class TacticArticlesController < ApplicationController
  delegate :point_as_key_table, :trigger_soldiers_hash, :other_objects_hash_ary, :other_objects_hash, :any_exist_soldiers, :to => "current_record.board_parser"

  helper_method :current_record

  def index
    params[:mode] ||= "list"

    case params[:mode]
    when "list"
      @rows = Warabi::TacticInfo.flat_map do |group|
        group.model.collect { |e| row_build(e) }
      end
    when "tree"
      @tree = Warabi::TacticInfo.flat_map do |group|
        group.model.find_all(&:root?).collect { |root|
          root.to_s_tree do |e|
            link_to(e.name, [:tactic_article, id: e.key])
          end
        }.join
      end
    when "fortune"
      @attack_info = Warabi::AttackInfo.to_a.sample
      @defense_info = Warabi::DefenseInfo.to_a.sample
    end
  end

  def show
    # ○ 何もない
    # ● 何かある
    # ☆ 移動元ではない

    @board_table = tag.table(:class => "tactic_board_table") do
      Warabi::Position::Vpos.board_size.times.collect { |y|
        tag.tr {
          Warabi::Position::Hpos.board_size.times.collect { |x|
            td_class = []

            point = Warabi::Point.fetch([x, y])
            str = nil

            # トリガー駒
            if soldier = trigger_soldiers_hash[point]
              td_class << "location_#{soldier[:location].key}"
              td_class << "current"
              str = soldier.any_name
            else
              # トリガーではない駒
              if soldier = point_as_key_table[point]
                td_class << "location_#{soldier[:location].key}"
                str = soldier.any_name
              end
            end

            # 何もない
            if v = other_objects_hash["○"]
              if v[point]
                td_class << "cell_blank"
              end
            end

            # 何かある
            if v = other_objects_hash["●"]
              if v[point]
                td_class << "something_exist"
              end
            end

            # 移動元
            if v = other_objects_hash["★"]
              if v[point]
                td_class << "origin_point"
              end
            end

            # 移動元ではない
            if v = other_objects_hash["☆"]
              if v[point]
                td_class << "not_any_from_point"
                str = icon_tag(:fab, :times)
              end
            end

            # どれかの駒がある
            if soldier = any_exist_soldiers.find {|e| e[:point] == point }
              td_class << "location_#{soldier[:location].key}"
              td_class << "any_exist_soldiers"
              str = soldier.any_name
            end

            tag.td(str, :class => td_class)
          }.join.html_safe
        }
      }.join.html_safe
    end

    row = row_build(current_record)
    if v = other_objects_hash_ary["☆"]
      row["移動元制限"] = v.collect { |e| e[:point].name }.join("、").html_safe + "が移動元ではない"
    end
    @detail_hash = row.transform_values(&:presence).compact

    all_records = Warabi::TacticInfo.all_elements
    if index = all_records.find_index(current_record)
      @left_right_link = tag.navi(:class => "pagination is-right", role: "navigation", "aria-label": "pagination") do
        [
          [-1, [:play, :rotate_180], "pagination-previous"],
          [+1, [:play],              "pagination-next"],
        ].collect { |s, icon, klass|
          r = all_records[(index + s).modulo(all_records.size)]
          link_to(icon_tag(:fas, *icon), [:tactic_article, id: r.key], :class => klass)
        }.join(" ").html_safe + tag.ul("class": "pagination-list")
      end
    end
  end

  def current_record
    @current_record ||= -> {
      v = nil
      Warabi::TacticInfo.each do |e|
        if v = e.model.lookup(params[:id])
          break
        end
      end
      v
    }.call
  end

  private

  def row_build(e)
    row = {}

    if detail?
    else
      row["名前"] = link_to(e.key, [:tactic_article, id: e.key])
    end
    row["種類"] = e.tactic_info.name
    row["別名"] = e.alias_names.join(", ")

    if detail?
      root = e.root
      unless root.children.empty?
        row["系図"] = tag.pre(:class => "tree") do
          root.to_s_tree { |o|
            if o.key == e.key
              o.name
            else
              link_to(o.name, [:tactic_article, id: o.key])
            end
          }.html_safe
        end
      end
    else
      row["親"] = e.parent ? link_to(e.parent.name, [:tactic_article, id: e.parent.key]) : nil
      row["兄弟"] = e.siblings.collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe
      row["派生"] = e.children.collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe
    end
    row["別親"] = Array(e.other_parents).collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe

    row["手数制限"] = e.turn_limit ? "#{e.turn_limit}手以内" : nil
    row["手数限定"] = e.turn_eq ? "#{e.turn_eq}手目" : nil

    str = nil
    if e.order_key
      str = (e.order_key == :sente) ? "▲" : "△"
      str = "#{str}限定"
    end
    row["手番"] = str

    row["歩がない"] = e.not_have_pawn ? checked : nil
    row["打時"] = e.drop_only ? checked : nil
    row["キル時"] = e.kill_only ? checked : nil
    row["開戦前"] = e.cold_war ? checked : nil
    row["所持あり"] = e.hold_piece_in ? e.hold_piece_in.to_s : nil,
    row["所持なし"] = e.hold_piece_not_in ? e.hold_piece_not_in.to_s : nil,
    row["持駒が空"] = e.hold_piece_empty ? checked : nil
    row["持駒一致"] = e.hold_piece_eq ? e.hold_piece_eq.to_s : nil
    row["歩以外不所持"] = e.not_have_anything_except_pawn ? checked : nil

    # if e.compare_condition
    #   row["比較"] = e.compare_condition == :include ? "含まれる" : "完全一致"
    # end

    if true
      urls = e.urls.sort

      if detail?
        urls << h.google_search_url(e.name)
        urls << h.youtube_search_url(e.name)

        str = urls.collect { |e|
          case e
          when /mijinko83/
            name = "続・裏小屋日記 完結編"
          when /wikipedia/
            name = "Wikipedia"
          when /siratama/
            name = "しらたまの甘味所"
          when /google/
            name = "Google 検索"
          when /youtube.*watch/
            name = "動画"
          when /youtube/
            name = "Youtube 検索"
          when /mudasure/
            name = "ムダスレ無き改革"
          else
            name = e.truncate(32)
          end
          link_to(name, e, target: "_blank")
        }.join(tag.br).html_safe
      else
        str = urls.collect.with_index { |e, i|
          link_to(("A".ord + i).chr, e, target: "_blank")
        }.join(" ").html_safe
      end
      row["参考URL"] = str
    end

    row
  end

  def checked
    Fa.icon_tag(:fas, :check)
  end

  def detail?
    params[:action] == "show"
  end
end
