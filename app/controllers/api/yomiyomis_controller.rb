module Api
  class YomiyomisController < ::Api::ApplicationController
    include EncodeMod
    include KifShowMod
    include ShogiErrorRescueMod

    def show
      # # slack_message(key: "Yomiyomi", body: {
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

    def config_params
      {
        record: current_json,
        twitter_card_options: twitter_card_options,
      }
    end

    def twitter_card_options
      {
        :title       => current_page_title,
        :image       => current_og_image_path,
        :description => params[:description].presence || current_record.simple_versus_desc || "",
      }
    end

    def current_title
      params[:title].presence || "共有将棋盤"
    end

    def current_page_title
      [current_title, turn_full_message].compact.join(" ")
    end

    # これは JS 側で作る手もある。そうすればリアルタイムに更新できる。が、og:image なのでリアルタイムな必要がない。迷う。
    # API 単体として使う場合は API の方で作っておいた方が都合がよい
    # ので、こっちで作るのであってる
    # http://0.0.0.0:3000/api/yomiyomi.json?turn=1&title=%E3%81%82%E3%81%84%E3%81%88%E3%81%86%E3%81%8A
    def current_og_image_path
      # if true
      #   # params[:image_viewpoint] が渡せていないけどこれでいい
      #   # url_for([:yomiyomi, body: current_record.sfen_body, only_path: false, format: "png", turn: initial_turn, image_viewpoint: image_viewpoint])
      # else
      #   # params[:image_viewpoint] をそのまま渡すために params にマージしないといけない
      #   # url_for([:yomiyomi, params.to_unsafe_h.merge(body: current_record.sfen_body, format: "png")])
      # end

      # ../../front_app/components/Yomiyomi/YomiyomiApp.vue の permalink_for と一致させること
      args = params.to_unsafe_h.except(:action, :controller, :format).merge({
                                                                              :turn             => initial_turn,
                                                                              :title            => current_title,
                                                                              :body             => current_record.sfen_body,
                                                                              :abstract_viewpoint => abstract_viewpoint,
                                                                            })

      "/share-board.png?#{args.to_query}"
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

      # リアルタイム共有
      attrs = attrs.merge({
                            :room_code => params[:room_code] || "",
                            :user_code => SecureRandom.hex,
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
