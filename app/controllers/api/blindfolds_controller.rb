module Api
  class BlindfoldsController < ::Api::ApplicationController
    include ShogiErrorRescueMod

    def show
      render json: { record: current_record.as_json(only: [:sfen_body, :turn_max]) }
    end

    def create
      info = Bioshogi::Parser.parse(params[:sfen])
      render json: { yomiage_body: info.to_yomiage }
    end

    private

    def current_record
      @current_record ||= FreeBattle.same_body_fetch(params)
    end
  end
end
