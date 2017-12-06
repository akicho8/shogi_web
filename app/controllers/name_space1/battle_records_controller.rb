# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味               | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |                  |       |
# | unique_key         | ユニークなハッシュ | string(255) | NOT NULL    |                  | A     |
# | battle_key         | Battle key         | string(255) | NOT NULL    |                  | B     |
# | battled_at         | Battled at         | datetime    | NOT NULL    |                  |       |
# | battle_group_key   | Battle group key   | string(255) | NOT NULL    |                  | C     |
# | csa_seq            | Csa seq            | text(65535) | NOT NULL    |                  |       |
# | battle_result_key  | Battle result key  | string(255) | NOT NULL    |                  | D     |
# | win_battle_user_id | Win battle user    | integer(8)  |             | => BattleUser#id | E     |
# | turn_max           | 手数               | integer(4)  |             |                  |       |
# | kifu_header        | 棋譜ヘッダー       | text(65535) |             |                  |       |
# | sanmyaku_view_url  | Sanmyaku view url  | string(255) |             |                  |       |
# | created_at         | 作成日時           | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |                  |       |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

module NameSpace1
  class BattleRecordsController < ApplicationController
    include ModulableCrud::All

    private

    def raw_current_record
      if v = params[:id].presence
        BattleRecord.import_by_battle_key(v)
        current_scope.find_by!(battle_key: v)
      else
        current_scope.new
      end
    end

    concerning :SharedMethods do
      included do
        if Rails.env.production?
          if v = ENV["HTTP_BASIC_AUTHENTICATE"].presence
            http_basic_authenticate_with Hash[[:name, :password].zip(v.split(/:/))].merge(only: [:index, :edit, :update, :destroy])
          end
        end

        rescue_from "Bushido::BushidoError" do |exception|
          h = ApplicationController.helpers
          lines = exception.message.lines
          message = lines.first.strip.html_safe
          if field = lines.drop(1).join.presence
            message += "<br>".html_safe
            message += h.content_tag(:pre, field).html_safe
          end
          unless Rails.env.production?
            if exception.backtrace
              message += h.content_tag(:pre, exception.backtrace.first(8).join("\n").html_safe).html_safe
            end
          end
          behavior_after_rescue(message)
        end
      end

      def show
        if params[:sanmyaku]
          current_record.sanmyaku_post_onece

          # 通常リンク(remote: false)の場合
          if true
            if request.format.html?
              if current_record.sanmyaku_view_url
                redirect_to current_record.sanmyaku_view_url
              else
                # 無限ループしないように fallback_location に sanmyaku を含めないこと
                # redirect_back を使うと referer に sanmyaku に含まれていて無限ループするはずなので注意
                raise MustNotHappen if params[:fallback_location].to_s.include?("sanmyaku")
                redirect_to params[:fallback_location], notice: "混み合っているようです"
              end
              return
            end
          end

          logger.info({sanmyaku_view_url: current_record.sanmyaku_view_url}.to_t)
          render "name_space1/battle_records/show"
          return
        end

        respond_to do |format|
          format.html
          format.any { kifu_send_data }
        end
      end

      private

      def current_filename
        "#{current_record.battle_key}.#{params[:format]}"
      end

      def kifu_send_data
        converted_info = current_record.converted_infos.find_by!(converted_format: params[:format])
        converted_body = converted_info.converted_body

        if access_from_swf_kifu_player?
          response.headers["Content-Type"] = 'text/plain; charset=shift_jis' # 指定しないと utf-8 で返してしまう(が、なくてもよい)
          logger.info response.headers.to_t
          render plain: converted_body.tosjis
          return
        end

        if params[:shift_jis].present? || params[:sjis].present?
          converted_body = converted_body.tosjis
        end

        send_data(converted_body, type: Mime[params[:format]], filename: current_filename.encode(current_encode), disposition: true ? "inline" : "attachment")
      end

      # Kifu.swf から呼ばれたときは日付のキーが含まれている
      # Started GET "/r/hanairobiyori-ispt-20171104_220810.kif?20171205090818"
      def access_from_swf_kifu_player?
        params.to_unsafe_h.any? { |k, v| v.blank? && (Date.parse(k) rescue nil) }
      end

      def current_encode
        params[:encode].presence || current_encode_default
      end

      def current_encode_default
        if request.user_agent.to_s.match(/Windows/i)
          "Shift_JIS"
        else
          "UTF-8"
        end
      end

      def behavior_after_rescue(message)
        redirect_to :root, alert: message
      end
    end
  end
end
