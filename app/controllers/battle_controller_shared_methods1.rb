module BattleControllerSharedMethods1
  extend ActiveSupport::Concern

  included do
    before_action only: [:edit, :update, :destroy] do
      if request.format.html?
        unless editable_record?(current_record)
          message = ["アクセス権限がありません"]
          if Rails.env.development?
            message << "(フッターのデバッグリンクから任意のユーザーまたは sysop でログインしてください)"
          end
          redirect_to :root, alert: message
        end
      end
    end

    rescue_from "Bioshogi::BioshogiError" do |exception|
      if request.format.json?
        render json: {error_message: exception.message.lines.first.strip}
      else
        h = ApplicationController.helpers
        lines = exception.message.lines
        message = lines.first.strip.html_safe
        if field = lines.drop(1).presence
          message += h.tag.div(field.join.html_safe, :class => "error_message_pre").html_safe
        end
        if v = exception.backtrace
          message += h.tag.div(v.first(8).join("\n").html_safe, :class => "error_message_pre").html_safe
        end
        behavior_after_rescue(message)
      end
    end
  end

  def show
    access_log_create

    respond_to do |format|
      format.html
      format.png { send_png_file }
      format.any { kifu_send_data }
    end
  end

  def update
    if v = params[:image_turn]
      current_record.update!(image_turn: v)
    end

    if params[:canvas_image_base64_data_url]
      render json: current_record.canvas_data_save(params)
      return
    end

    if params[:gazodetukuru]
      render json: current_record.canvas_data_save2(params)
      return
    end

    if params[:og_image_destroy]
      render json: current_record.canvas_data_destroy(params)
      return
    end

    super
  end

  private

  def send_png_file
    # 手数の指定があればリアルタイムに作成
    if current_force_turn
      user_params = params.to_unsafe_h.symbolize_keys.transform_values { |e| Float(e) rescue e }
      options = current_record.image_default_options.merge(user_params)
      png = Rails.cache.fetch(options, expires_in: Rails.env.production? ? 1.days : 0) do
        parser = Bioshogi::Parser.parse(current_record.existing_sfen, typical_error_case: :embed, turn_limit: current_force_turn)
        parser.to_png(options)
      end
      send_data png, type: Mime[:png], disposition: :inline, filename: "#{current_record.id}-#{current_force_turn}.png"
      return
    end

    # 画像がなければ作る
    current_record.image_auto_cerate_onece
    key = current_record.tweet_image.processed.key
    path = ActiveStorage::Blob.service.path_for(key)
    send_file path, type: current_record.thumbnail_image.content_type, disposition: :inline, filename: "#{current_record.id}.png"
  end

  def zip_download_limit
    (params[:limit].presence || AppConfig[:zip_download_limit_default]).to_i.clamp(0, AppConfig[:zip_download_limit_max])
  end

  def current_filename
    "#{current_record.key}.#{params[:format]}"
  end

  # curl -I http://localhost:3000/x/1.kif?inline=1
  # curl -I http://localhost:3000/x/1.kif?plain=1
  def kifu_send_data
    require "kconv"

    text_body = current_record.to_cached_kifu(params[:format])

    if params[:copy_trigger]
      SlackAgent.message_send(key: "#{params[:format]}コピー", body: current_record.to_title)
    end

    # 激指ではクリップボードは UTF8 でないと読めない
    # if sjis_p?
    #   text_body = text_body.tosjis
    # end

    if params[:plain].present?
      render plain: text_body
      return
    end

    if params[:inline].present?
      disposition = "inline"
    else
      disposition = "attachment"

      # ↓これをやるとコピーのときに sjis 化されてぴよで読み込めなくなる
      #
      # iPhone で「ダウンロード」としたときだけ文字化けする対策(sjisなら文字化けない)
      # if mobile_agent?
      #   text_body = text_body.tosjis
      # end
    end

    send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{current_encode}"), disposition: disposition)
  end

  def current_encode
    params[:encode].presence || current_encode_default
  end

  def current_encode_default
    if sjis_p?
      "sjis"
    else
      "utf8"
    end
  end

  def sjis_p?
    request.user_agent.to_s.match(/Windows/i) || params[:shift_jis].present? || params[:sjis].present?
  end

  def behavior_after_rescue(message)
    redirect_to :root, danger: message
  end

  def access_log_create
  end
end
