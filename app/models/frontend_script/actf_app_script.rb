# 詰将棋ファイター
#
# entry
#   app/models/frontend_script/actf_app_script.rb
#
# vue
#   app/javascript/actf_app/index.vue
#
# db
#   db/migrate/20200505135600_create_actf.rb
#
# test
#   experiment/0860_actf.rb
#
# model
#   app/models/actf/membership.rb
#   app/models/actf/room.rb
#   app/models/actf.rb
#   app/models/colosseum/user_actf_mod.rb
#
#   question
#     app/models/actf/question.rb
#     app/models/actf/moves_answer.rb
#     app/models/actf/endpos_answer.rb
#
# channel
#   app/channels/actf/lobby_channel.rb
#   app/channels/actf/room_channel.rb
#
# job
#   app/jobs/actf/lobby_broadcast_job.rb
#   app/jobs/actf/message_broadcast_job.rb
#
module FrontendScript
  class ActfAppScript < ::FrontendScript::Base
    include AtomicScript::AddJsonLinkMod
    include SortMod

    self.script_name = "詰将棋ファイター"
    self.page_title = ""
    self.form_position = :bottom

    delegate :current_user, to: :h

    QUESTIONS_FETCH_PER = 10
    RANKING_FETCH_MAX = 50
    HISTORY_FETCH_MAX = 50

    def form_parts
      if Rails.env.development?
        [
          {
            :label   => "画面",
            :key     => :debug_scene,
            :elems   => { "ロビー" => nil, "対戦" => :room, "結果" => :result, "編集"  => :builder, "ランキング" => :ranking, "履歴" => :history, },
            :type    => :select,
            :default => current_debug_scene,
          },
        ]
      end
    end

    # http://localhost:3000/admin/script/actf-sample.json?questions_fetch=true
    def script_body
      if params[:questions_fetch]
        params[:per] ||= QUESTIONS_FETCH_PER

        s = current_user.actf_questions
        s = page_scope(s)       # page_mod.rb
        s = sort_scope(s)       # sort_mod.rb

        retv = {**page_info(s), **sort_info}
        retv[:questions] = s.as_json(include: [:user, :moves_answers])  # FIXME:必要なのだけにする]
        return retv
      end

      if params[:ranking_fetch]
        s = Colosseum::User.all
        s = s.joins(:actf_profile).order(Actf::Profile.arel_table[params[:ranking_key]].desc).order(:created_at)
        s = s.limit(RANKING_FETCH_MAX)

        retv = {}
        # retv = {**page_info(s), **sort_info}
        retv[:ranking_key] = params[:ranking_key]
        retv[:rank_records] = s.shuffle.as_json(only: [:id, :name], methods: [:avatar_path, :rating, :rensho_count, :rensho_max])
        return retv
      end

      if params[:history_fetch]
        s = current_user.actf_histories.order(created_at: :desc).limit(HISTORY_FETCH_MAX)
        retv = {}
        retv[:history_records] = s.as_json(only: [:id], include: {:room => {}, :membership => {}, :question => {include: {:user => {only: [:id, :key, :name], methods: [:avatar_path]}}}, :ans_result => {only: :key}})
        return retv
      end

      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys
      #
      # question = current_user.actf_questions.find_or_initialize_by(id: params[:question][:id])
      # question.together_with_params_came_from_js_update(params)
      # return question.create_the_parameters_to_be_passed_to_the_js

      # question = current_user.actf_questions.create! do |e|
      #   e.assign_attributes(params[:question])
      #   # e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
      #   e.moves_answers.build(moves_str: "G*5b")
      #   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
      # end

      # Actf.setup

      if params[:login_required]
        unless current_user
          h.session[:return_to] = h.url_for(script_link_path)
          c.redirect_to :new_xuser_session
          return
        end
      end

      out = ""

      # return ActionCable.server.open_connections_statistics
      # .map { |con| con[:subscriptions]
      #   .map { |sub| JSON.parse(sub)["url"] } } # ここのurlを変えれば特定の接続数を取得できるはず
      # .flatten
      # .select { |url| url == 'http:himakannet' } # ここで特定のチャネル一致
      # .size

      if request.format.json?
      end

      # if !current_room
      #   out += Actf::Room.order(:id).collect { |room|
      #     {
      #       "チャットルーム" => h.link_to(room.id, params.merge(room_id: room.id)),
      #     }
      #   }.to_html
      # end

      if current_room
        #   messages = current_room.messages.order(:id).last(10)
        #   rendered_messages = messages.collect { |message|
        #     ApplicationController.renderer.render partial: 'actf/messages/message', locals: { message: message }
        #   }
      end

      info = {}

      debug_scene_set(info)

      info[:mode] ||= "lobby"
      info[:put_path] = h.url_for(script_link_path)
      info[:question_default] = question_default

      if current_user
        info[:current_user] = current_user.as_json(only: [:id, :key, :name], methods: [:avatar_path, :rating])
      end

      # info[:room] = current_room
      # info[:messages] = rendered_messages
      if request.format.json?
        return info
      end
      #
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><actf_app :info='#{info.to_json}' /></div>)
      # out += h.tag.br
      # out += h.link_to("ロビー", params.merge(room_id: nil), :class => "button is-small")
      # end

      c.layout_type = :raw

      out
    end

    def put_action
      # params = {
      #   "question" => {
      #     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p #{rand(1000000)}",
      #     "moves_answers"=>[{"moves_str"=>"4c5b"}],
      #     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
      #   },
      # }.deep_symbolize_keys

      question = current_user.actf_questions.find_or_initialize_by(id: params[:question][:id])
      begin
        question.together_with_params_came_from_js_update(params)
      rescue ActiveRecord::RecordInvalid => error
        c.render json: { error_message: error.message }
        return
      end
      c.render json: { question: question.create_the_parameters_to_be_passed_to_the_js.as_json }
    end

    def current_room_id
      params[:room_id].presence
    end

    def current_room
      if v = current_room_id
        Actf::Room.find_by(id: v)
      end
    end

    def sort_column_default
      :updated_at
    end

    def current_debug_scene
      if v = params[:debug_scene].presence
        v.to_sym
      end
    end

    def question_default
      {
        # // init_sfen: "4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
        # // init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
        init_sfen: "7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
        moves_answers: [
          moves_str: "1c1b",
          end_sfen: "7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2",
        ],
        time_limit_sec: 3 * 60,
        difficulty_level: 1,
        title: "(title)",
        display_key: "public",
      }
    end

    def debug_scene_set(info)
      info[:debug_scene] = current_debug_scene

      if current_debug_scene == :room
        c.sysop_login_unless_logout

        user = Colosseum::User.create!
        room = Actf::Room.create! do |e|
          e.memberships.build(user: current_user)
          e.memberships.build(user: user)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :question_index], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:simple_quest_infos, :final_info])
      end

      if current_debug_scene == :result
        c.sysop_login_unless_logout

        user1 = current_user
        user2 = Colosseum::User.create!
        room = Actf::Room.create!(final_key: :disconnect) do |e|
          e.memberships.build(user: user1, judge_key: :win,  question_index: 1)
          e.memberships.build(user: user2, judge_key: :lose, question_index: 2)
        end

        info[:room] = room.as_json(only: [:id], include: { memberships: { only: [:id, :judge_key, :rensho_count, :renpai_count, :question_index], include: {user: { only: [:id, :name], methods: [:avatar_path], include: {actf_profile: { only: [:id, :rensho_count, :renpai_count, :rating, :rating_max, :rating_last_diff, :rensho_max, :renpai_max] } } }} }}, methods: [:simple_quest_infos, :final_info])
      end

      if current_debug_scene == :edit
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :ranking
        c.sysop_login_unless_logout
      end

      if current_debug_scene == :history
        c.sysop_login_unless_logout
      end
    end
  end
end
