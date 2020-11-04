# 将棋トレーニングバトル
#
# entry
#   app/controllers/api/emox_controller.rb
#
# vue
#   app/javascript/emox_app/index.vue
#
# db
#   db/migrate/20200505135600_create_emox.rb
#
# test
#   experiment/0860_emox.rb
#
# model
#   app/models/emox/membership.rb
#   app/models/emox/battle.rb
#   app/models/emox.rb
#   app/models/colosseum/user_emox_mod.rb
#
#   question
#     app/models/emox/question.rb
#     app/models/emox/moves_answer.rb
#
# channel
#   app/channels/emox/lobby_channel.rb
#   app/channels/emox/battle_channel.rb
#
# job
#   app/jobs/emox/lobby_broadcast_job.rb
#   app/jobs/emox/message_broadcast_job.rb
#

module Api
  class EmoxController < ::Api::ApplicationController
    # FIXME: GET, PUT で分けるのではなく関心で分離する
    include GetApi
    include PutApi
    include ZipDlMod

    include DebugMod

    # self.script_name = "将棋トレーニングバトル"
    # self.page_title = ""
    # self.form_position = :bottom
    # self.column_wrapper_enable = false

    # if Rails.env.production?
    #   self.visibility_hidden_on_menu = true
    # end

    # delegate :current_user, to: :h

    # http://0.0.0.0:3000/api/emox
    def show
      if v = params[:remote_action]
        v = public_send(v)
        if performed?
          return
        end
        render json: v
        return
      end

      # # for OGP
      # case
      # when e = current_question
      #   ogp_params_set({
      #       :card        => :summary_large_image,
      #       :title       => e.title_with_author,
      #       :description => e.description,
      #       :image       => e.shared_image_params,
      #       :creator     => e.user.twitter_key,
      #     })
      # when e = User.find_by(id: params[:user_id])
      #   ogp_params_set({
      #       :card        => :summary,
      #       :title       => "#{e.name}さんのプロフィール",
      #       :description => "",
      #       :image       => e.avatar_path,
      #       :creator     => e.twitter_key,
      #     })
      # else
      #   ogp_params_set({
      #       :title       => "将棋トレーニングバトル",
      #       :description => "クイズ形式で将棋の問題を解く力を競う対戦ゲームです",
      #     })
      # end

      ################################################################################

      info = {}
      info[:config] = Emox::Config
      info[:mode] ||= "lobby"   # FIXME: とる
      # info[:api_path] = h.url_for(script_link_path)
      info[:question_default_attributes] = Emox::Question.default_attributes

      warp_to_params_set(info)  # current_user のデータを作ることもあるので current_user のセットの前で行うこと

      if current_user
        info[:current_user] = current_user.as_json_type9x

        if true
          # すでにログインしている人は maincable で unauthorized になる
          # これはクッキーに記録しないままログインしたのが原因
          # なのですでにログインしていたらクッキーに埋める
          current_user_set_for_action_cable(current_user)
        end
      end

      # if Rails.env.development?
      #   Emox::BaseChannel.redis_clear
      # end

      # http://0.0.0.0:3000/api/emox.json
      if request.format.json?
        render json: info
        return
      end

      # zip の場合はここにくるっぽい

      ################################################################################

      # out = ""
      # out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      # out += %(<div id="app"><emox_app :info='#{info.to_json}' /></div>)
      # out
    end

    def update
      v = public_send(params[:remote_action])
      raise v.inspect unless v.kind_of?(Hash)
      render json: v
    end

    def current_battle_id
      params[:battle_id].presence
    end

    def current_battle
      if v = current_battle_id
        Emox::Battle.find_by(id: v)
      end
    end

    def users
      [current_user, User.bot]
    end

    concerning :QuestionOgpMethods do
      def current_question
        @current_question ||= __current_question
      end

      def __current_question
        if v = params[:question_id]
          Emox::Question.find(v)
        end
      end
    end
  end
end
