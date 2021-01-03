module Yomiyomi
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      return reject unless room_code
      stream_from "yomiyomi/room_channel/#{room_code}"
    end

    def board_info_request(data)
      broadcast(:board_info_request_broadcasted, data)
    end

    def board_info_send(data)
      broadcast(:board_info_send_broadcasted, data)
    end

    def sfen_share(data)
      broadcast(:sfen_share_broadcasted, data)
    end

    def title_share(data)
      broadcast(:title_share_broadcasted, data)
    end

    def room_code
      params["room_code"].presence
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("yomiyomi/room_channel/#{room_code}", {bc_action: bc_action, bc_params: bc_params})
    end
  end
end
