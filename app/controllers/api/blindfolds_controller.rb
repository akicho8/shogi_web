module Api
  class BlindfoldsController < ::Api::ApplicationController
    include EncodeMod
    include KifShowMod
    include ShogiErrorRescueMod

    # before_action do
    #   params[:body] ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
    # end

    def show
      # # slack_message(key: "Blindfold", body: {
      # #     "request.format"        => request.format,
      # #     "request.format.blank?" => request.format.blank?,
      # #     "request.format.html?"  => request.format.html?,
      # #     "params[:format]"       => params[:format],
      # #     "params"                => params,
      # #   })
      #
      # # http://localhost:3000/share-board
      # if params[:format].blank? || request.format.html?
      #   query = params.permit!.to_h.except(:controller, :action, :format).to_query.presence
      #   redirect_to UrlProxy.wrap(["/share-board", query].compact.join("?"))
      #   # else
      #   #   redirect_to ["/app/share-board", query].compact.join("?")
      #   # end
      #   # redirect_to UrlProxy.wrap(["/share-board", query].compact.join("?"))
      #   # redirect_to UrlProxy.wrap(["/app/share-board", query].compact.join("?"))
      #   return
      # end

      # # アクセスがあれば「上げて」消さないようにするため
      # current_record.update_columns(accessed_at: Time.current)

      if request.format.json?
        # if params[:config_fetch]
        render json: config_params
        return
        # end
      end

      # # Twitter画像
      # # http://localhost:3000/share-board.png?body=position+sfen+lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1+moves+2g2f
      # if request.format.png?
      #   png = current_record.to_dynamic_png(params.merge(turn: initial_turn, viewpoint: image_viewpoint))
      #   send_data png, type: Mime[:png], disposition: current_disposition, filename: current_filename
      #   return
      # end

      # http://localhost:3000/share-board.kif
      # http://localhost:3000/share-board.ki2
      # http://localhost:3000/share-board.sfen
      # http://localhost:3000/share-board.csa
      kif_data_send
    end

    def create
      info = Bioshogi::Parser.parse(params[:sfen])
      render json: { yomiage_body: info.to_yomiage }
    end

    def config_params
      {
        record: current_json,
        twitter_card_options: twitter_card_options,
      }
    end

    def twitter_card_options
      {
        :title       => current_page_title,
        :image       => "",
        :description => "",
      }
    end

    def current_title
      params[:title].presence || "目隠し将棋"
    end

    def current_page_title
      [current_title, turn_full_message].compact.join(" ")
    end

    private

    def current_filename
      basename = params[:title].presence || current_record.to_param
      "#{basename}-#{initial_turn}.#{params[:format]}"
    end

    def turn_full_message
      if initial_turn.nonzero? || true
        "#{initial_turn}手目"
      end
    end

    # HTMLはリダイレクトしてしまうのでそのまま表示する
    def behavior_after_rescue(message)
      # redirect_to controller_name.singularize.to_sym, danger: message
      # render html: message.html_safe
      render html: message.html_safe
    end

    def current_json
      attrs = current_record.as_json(only: [:sfen_body, :turn_max])
      attrs = attrs.merge({
                            :initial_turn        => initial_turn,
                            :board_viewpoint        => board_viewpoint,
                            :abstract_viewpoint => abstract_viewpoint,
                            :title               => current_title,
                          })

      attrs
    end

    def current_record
      @current_record ||= FreeBattle.same_body_fetch(params)
    end

    def initial_turn
      v = (params[:turn].presence || current_record.turn_max).to_i
      current_record.adjust_turn(v)
    end

    def board_viewpoint
      if v = params[:board_viewpoint].presence
        return v
      end
      # # 次に指す人の視点で開くなら
      # if true
      #   number_of_turns_in_consideration_of_the_frame_dropping.odd?
      # end
      abstract_viewpoint_info.board_viewpoint.call(number_of_turns_in_consideration_of_the_frame_dropping)
    end

    def image_viewpoint
      # 視点設定用
      # ビュー側で確認用画像を表示するため board_viewpoint の結果で画像をflipする
      if params[:__board_viewpoint_as_image_viewpoint__] == "true"
        return board_viewpoint
      end

      if v = params[:image_viewpoint].presence
        return v
      end
      abstract_viewpoint_info.image_viewpoint.call(number_of_turns_in_consideration_of_the_frame_dropping)
    end

    def abstract_viewpoint_info
      AbstractViewpointInfo.fetch(abstract_viewpoint)
    end

    def abstract_viewpoint
      AbstractViewpointInfo.valid_key(params[:abstract_viewpoint], :self)
    end

    # 駒落ちを考慮した擬似ターン数
    def number_of_turns_in_consideration_of_the_frame_dropping
      current_record.sfen_info.location.code + initial_turn
    end
  end
end
