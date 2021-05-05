module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      return reject unless room_code
      simple_track("IN")
      stream_from "share_board/room_channel/#{room_code}"
    end

    def unsubscribed
      simple_track("OUT")
    end

    def force_sync(data)
      track(data, "局面配布", data.slice("turn_offset", "sfen"))
      broadcast(:force_sync_broadcasted, data)
    end

    def sfen_share(data)
      track(data, "指し手送信", "[#{data["turn_offset"]}] #{data["last_move_kif"]}")
      broadcast(:sfen_share_broadcasted, data)
    end

    def received_ok(data)
      track(data, "指し手受信", "OK > #{data['to_user_name']}")
      broadcast(:received_ok_broadcasted, data)
    end

    def sfen_share_not_reach(data)
      track(data, "指し手不達", "#{data['sfen_share_not_reach_count']}回目")
      raise StandardError, "指し手不達(#{data['sfen_share_not_reach_count']}回目) : #{data}"
    end

    def title_share(data)
      track(data, "タイトル変更", "#{data["title"].inspect} に変更しました")
      broadcast(:title_share_broadcasted, data)
    end

    def setup_info_request(data)
      track(data, "情報要求", "ください > ALL")
      broadcast(:setup_info_request_broadcasted, data)
    end

    def setup_info_send(data)
      track(data, "情報送信", "あげます > #{data["to_user_name"]}")
      broadcast(:setup_info_send_broadcasted, data)
    end

    def chess_clock_share(data)
      if data["message"].present?
        values = data["cc_params"].fetch_values("initial_main_min", "initial_read_sec", "initial_extra_sec", "every_plus")
        track(data, "対局時計", "#{data["message"]} (#{values.join(" ")})")
      end
      broadcast(:chess_clock_share_broadcasted, data)
    end

    def member_info_share(data)
      track(data, "生存通知", "#{data['alive_notice_count']}回目 LV:#{data['active_level']} (#{data['from_user_code']})") unless Rails.env.production?
      broadcast(:member_info_share_broadcasted, data)
    end

    def order_func_share(data)
      track(data, "順番機能", data["order_func_p"] ? "ON" : "OFF")
      broadcast(:order_func_share_broadcasted, data)
    end

    def ordered_members_share(data)
      user_names = data["ordered_members"].collect { |e| e["user_name"] }.join(" → ")
      track(data, "順番設定", user_names)
      broadcast(:ordered_members_share_broadcasted, data)
    end

    def message_share(data)
      track(data, "チャット", data["message"])
      broadcast(:message_share_broadcasted, data)
    end

    def ping_command(data)
      # track(data, "PING", data["start_at"])
      broadcast(:ping_command_broadcasted, data)
    end

    def pong_command(data)
      # track(data, "PONG", data["start_at"])
      broadcast(:pong_command_broadcasted, data)
    end

    def aclog(data)
      track(data, data["subject"], data["body"])
    end

    def fake_error(data)
      track(data, "エラー発動確認", data)
      broadcast(:fake_error_broadcasted, data)
    end

    private

    def room_code
      params["room_code"].presence
    end

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        v = v.to_h.except(*Array(bc_params["__nil_check_skip_keys__"]))
        if v.present?
          raise ArgumentError, "値が nil のキーがある : #{v.inspect}"
        end
      end

      ActionCable.server.broadcast("share_board/room_channel/#{room_code}", {bc_action: bc_action, bc_params: bc_params})
    end

    def track(data, action, body)
      key = "共有将棋盤 [#{room_code}] #{action}"
      if Rails.env.development?
        SlackAgent.message_send(key: key, body: data)
      end
      prefix = data["from_user_name"] + ":"
      body = [prefix, body].compact.join(" ")
      SlackAgent.message_send(key: key, body: body)
    end

    def simple_track(action)
      if current_user
        body = current_user.name
      else
        body = ""
      end
      SlackAgent.message_send(key: "共有将棋盤 [#{room_code}] #{action}", body: body)
    end
  end
end
