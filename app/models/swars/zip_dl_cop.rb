# 続きからダウンロード関連
#
# UI
# front_app/components/Swars/SwarsBattleDownload.vue
#
# ダウンロード記録
# app/models/swars/zip_dl_log.rb
#
# スコープ別の処理
# app/models/swars/zip_dl_scope_info.rb
#
# Controller
# app/controllers/swars/zip_dl_mod.rb
#
# Experiment
# experiment/swars/zip_dl_cop.rb
#
# Test
# spec/models/swars/zip_dl_cop_spec.rb

module Swars
  class ZipDlCop
    include EncodeMod
    include SortMod

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def to_config
      config = {}
      config[:form_params_default] = {
        :zip_dl_scope_key  => "zdsk_inherit",
        :zip_dl_format_key => "kif",
        :zip_dl_max        => AppConfig[:zip_dl_max_default],
        :body_encode        => "UTF-8",
      }

      if current_user
        s = swars_zip_dl_logs
        s = s.order(:end_at)
        config[:swars_zip_dl_logs] = {
          :count => s.count,
          :last  => s.last,
        }
      end

      config[:scope_info] = ZipDlScopeInfo.inject({}) do |a, e|
        a.merge(e.key => {
            :key     => e.key,
            :name    => instance_eval(&e.name),
            :count   => instance_eval(&e.scope).count,
            :message => instance_eval(&e.message),
          })
      end

      config
    end

    def to_zip
      t = Time.current

      io = Zip::OutputStream.write_buffer do |zos|
        zip_dl_scope.each do |battle|
          if str = battle.to_xxx(kifu_format_info.key)
            zos.put_next_entry("#{swars_user.key}/#{battle.key}.#{kifu_format_info.key}")
            if current_body_encode == "Shift_JIS"
              str = str.encode(current_body_encode)
            end
            zos.write(str)
          end
        end
      end

      sec = "%.2f s" % (Time.current - t)
      SlackAgent.message_send(key: "ZIP #{sec}", body: zip_filename)

      # 前回から続きのスコープが変化すると zip_filename にも影響するので最後の最後に呼ぶ
      swars_zip_dl_logs_create!

      io
    end

    def zip_filename
      parts = []
      parts << "shogiwars"
      parts << swars_user.key
      parts << zip_dl_scope.count
      parts << Time.current.strftime("%Y%m%d%H%M%S")
      parts << kifu_format_info.key
      parts << current_body_encode
      str = parts.compact.join("-") + ".zip"
      str
    end

    # 続きから進められるようにダウンロード範囲を記録する
    def swars_zip_dl_logs_create!
      log_create(zip_dl_scope)
    end

    # 古い1件をダウンロードしたことにする
    def oldest_log_create
      scope = current_index_scope.order(battled_at: :asc).limit(1)
      log_create(scope)
    end

    private

    # 続きから進められるようにダウンロード範囲を記録する
    def log_create(s)
      if s.exists? && current_user
        a = s.first.battled_at
        b = s.last.battled_at
        a, b = [a, b].sort
        current_user.swars_zip_dl_logs.create! do |e|
          e.swars_user = swars_user
          e.query      = params[:query]
          e.dl_count   = s.count
          e.begin_at   = a            # 単なる記録なのでなくてもよい
          e.end_at     = b + 1.second # 次はこの日時以上を対象にする
        end
      end
    end

    def zip_dl_scope
      instance_eval(&zip_dl_scope_info.scope)
    end

    def zip_dl_max
      (params[:zip_dl_max].presence || AppConfig[:zip_dl_max_default]).to_i.clamp(0, AppConfig[:zip_dl_max_of_max])
    end

    def kifu_format_info
      @kifu_format_info ||= Bioshogi::KifuFormatInfo.fetch(zip_dl_format_info.key)
    end

    def zip_dl_format_info
      ZipDlFormatInfo.fetch(zip_dl_format_key)
    end

    def zip_dl_format_key
      params[:zip_dl_format_key].presence || "kif"
    end

    def continue_begin_at
      if current_user
        if e = swars_zip_dl_logs.order(:end_at).last
          e.end_at
        end
      end
    end

    def swars_zip_dl_logs
      @swars_zip_dl_logs ||= current_user.swars_zip_dl_logs.where(swars_user: swars_user)
    end

    def zip_dl_scope_info
      ZipDlScopeInfo.fetch(zip_dl_scope_key)
    end

    def zip_dl_scope_key
      (params[:zip_dl_scope_key].presence || "zdsk_inherit").to_sym
    end

    def current_user
      params[:current_user]
    end

    def swars_user
      params[:swars_user] or raise ArgumentError
    end

    def current_index_scope
      params[:current_index_scope] or raise ArgumentError
    end
  end
end
