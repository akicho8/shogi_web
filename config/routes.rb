
Rails.application.routes.draw do
  root "tops#show"

  get "health" => HealthResponder

  devise_for :xusers, {
    class_name: "::User",
    controllers: {
      omniauth_callbacks: "omniauth_callbacks",
    },
  }

  ################################################################################ プロフィール編集など

  resources :users, path: "accounts"

  ################################################################################ Debug

  match "eval", to: "eval#run", via: :all

  ################################################################################ ログアウト

  # namespace :colosseum, path: "" do
  resource :direct_session, only: [:create, :destroy]
  # end

  get :login, to: "login#show"

  ################################################################################ 将棋ウォーズ棋譜検索

  swars_search_shared_redirect_block = -> (params, request) {
    query = request.params.except(:format).to_query.presence
    path = nil

    # http://localhost:3000/w?flip=false&modal_id=devuser1-Yamada_Taro-20200101_123401&turn=34
    unless path
      if modal_id = request.params[:modal_id]
        path = { path: "/swars/battles/#{modal_id}", query: query }
      end
    end

    # http://0.0.0.0:3000/w?query=devuser1&latest_open_index=0&external_app_key=piyo_shogi
    unless path
      if request.params[:latest_open_index]
        user_key = request.params[:query]
        external_app_key = params[:external_app_key] || :piyo_shogi
        path = "/swars/users/#{user_key}/direct-open/#{external_app_key}"
      end
    end

    # http://0.0.0.0:3000/w?query=devuser1&user_info_show=true
    unless path
      if request.params[:user_info_show]
        user_key = request.params[:query]
        path = "/swars/users/#{user_key}"
      end
    end

    # http://0.0.0.0:3000/w?query=devuser1
    unless path
      path = { path: "/swars/search", query: query }
    end

    UrlProxy.wrap(path)
  }

  get "w",       format: "html", to: redirect(&swars_search_shared_redirect_block)
  get "w-light", format: "html", to: redirect(&swars_search_shared_redirect_block)

  namespace :swars, path: "" do
    resources :battles, path: "w"
  end

  resolve "Swars::User" do |user, options|
    swars_battles_path(query: user.to_param)
  end

  ################################################################################ 棋譜投稿

  resources :free_battles, path: "x"

  ################################################################################ 戦法トリガー事典

  resources :tactic_notes, path: "tactics", only: [:index, :show]

  get "tactics-tree",    to: "tactic_notes#index", defaults: {mode: "tree"},    as: :tree

  ################################################################################ 他サービス

  resource :share_board, path: "share-board", only: [:show]

  ################################################################################ 将棋トレーニングバトル

  # match "actb", to: "scripts#show", defaults: { id: "actb_app" }, via: [:get, :update]

  ################################################################################ scripts

  resources :scripts, :path => "script", :only => [:show, :update]

  ################################################################################ api

  # http://0.0.0.0:3000/ping
  # http://0.0.0.0:3000/ping.json
  # http://0.0.0.0:3000/ping.txt
  match "ping(.:format)", to: "api/etc#ping", via: :all, format: nil

  namespace :api, format: "json" do
    match "ping(.:format)",  to: "etc#ping",  via: :all, format: nil
    match "echo(.:format)",  to: "etc#echo",  via: :all, format: nil
    match "sleep(.:format)", to: "etc#sleep", via: :all, format: nil

    get "tsl_user_all(.:format)",      to: "etc#tsl_user_all"
    get "tsl_user_newest(.:format)",   to: "etc#tsl_user_newest"
    get "tsl_league_all(.:format)",    to: "etc#tsl_league_all"
    get "tsl_league_newest(.:format)", to: "etc#tsl_league_newest"

    post "swars/download_set(.:format)",                  to: "swars#download_set"
    post "swars/crawler_run(.:format)",                   to: "swars#crawler_run"
    get "swars/remember_swars_user_keys_fetch(.:format)", to: "swars#remember_swars_user_keys_fetch"
    get "swars/download_config_fetch(.:format)",          to: "swars#download_config_fetch"

    match "general/any_source_to(.:format)", to: "generals#any_source_to", via: :all, format: nil

    get "actb(.:format)", to: "actb#show",   format: nil # /actb.zip もある
    put "actb(.:format)", to: "actb#update", format: nil

    get "emox/resource_fetch(.:format)",                  to: "emox#resource_fetch"
    put "emox/session_lock_token_set_handle(.:format)",   to: "emox#session_lock_token_set_handle"
    put "emox/session_lock_token_valid_handle(.:format)", to: "emox#session_lock_token_valid_handle"
    put "emox/rule_key_set_handle(.:format)",             to: "emox#rule_key_set_handle"
    put "emox/debug_matching_add_handle(.:format)",       to: "emox#debug_matching_add_handle"
    put "emox/matching_users_clear_handle(.:format)",     to: "emox#matching_users_clear_handle"

    resource :session, only: [] do
      get :auth_user_fetch
      delete :auth_user_logout   # ログアウト
    end

    resource :settings, only: [] do
      put :profile_update
      get :email_fetch
      put :email_update
      get :swars_user_key_fetch
      put :swars_user_key_update
    end

    resource :adapter, only: [] do
      get :formal_sheet
      post :record_create
    end

    namespace :xy_master, format: "json" do
      resources :time_records, only: [:index, :create, :update]
    end

    namespace :ts_master, format: "json" do
      resources :time_records, only: [:index, :create, :update]
    end

    resource :talk, only: [:show, :create]
    resources :service_infos, only: :index
    resources :users
    resource :cpu_battle, only: [:show, :create]
    resource :share_board, only: [:show, :create]
    resource :blindfold, only: [:show, :create]
    resource :three_stage_league, only: [:show]
    resource :three_stage_league_player, only: [:show]
    resource :swars_grade_histogram, only: [:show]
    resource :swars_histogram, only: [:show]
    resource :professional, only: [:show]
    resource :top_group, only: [:show]
  end

  ################################################################################ admin

  namespace :admin do
    resource :session, only: :destroy
    resource :home, only: :show

    resources :scripts, path: "script", only: [:show, :update]

    resources :example_scripts, path: "example-script", only: [:show, :update]

    root "homes#show"
  end

  ################################################################################ sidekiq

  # require "sidekiq/monitor/stats" # <mounted-path>/monitor-stats
  require "sidekiq/web"
  mount Sidekiq::Web => "/admin/sidekiq" # authenticate :user {} で認証チェックする例がネットにあるが、それは devise のメソッド

  if Rails.env.production?
    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      [user, password] == ["admin", Rails.application.credentials[:admin_password]]
    end
  end

  if false
    # Sidekiq::Web.tabs.replace({"管理画面" => "/admin"}.merge(Sidekiq::Web.tabs))
    # Sidekiq::Web.tabs["管理画面に戻る"] = "/admin"
    Sidekiq::Web.tabs["管理画面に戻る"] = "http://localhost:3000/admin"
  end

  ################################################################################ 外部リンク

  direct :official_swars_battle do |battle, options = {}|
    "https://shogiwars.heroz.jp/games/#{battle.key}"
  end

  direct :swars_home do |user, options = {}|
    "https://shogiwars.heroz.jp/users/mypage/#{user.user_key}"
  end

  direct :piyo_shogi_app do |url, options|
    # if Rails.env.development?
    #   url = "http://wdoor.c.u-tokyo.ac.jp/shogi/LATEST//2016/09/24/wdoor+floodgate-600-10F+gpsfish_normal_1c+gps_l+20160924113005.csa"
    # end
    "piyoshogi://?#{options.to_query}&url=#{url}" # 渡すURLをエスケープするとぴよ将棋で読めなくなるので to_query してはいけない
  end

  direct :kento_app do |options, turn|
    "https://www.kento-shogi.com/?#{options.to_query}##{turn}"
  end

  direct :google_search do |query|
    "https://www.google.co.jp/search?q=#{query}"
  end

  direct :google_image_search do |query|
    "https://www.google.co.jp/search?tbm=isch&q=#{query}"
  end

  direct :twitter_search do |query|
    "https://twitter.com/search?q=#{query}"
  end

  direct :google_maps do |query|
    "https://www.google.co.jp/maps/search/#{query}"
  end

  direct :youtube_search do |query|
    "https://www.youtube.com/results?search_query=#{query}&search=Search"
  end

  direct :production_app do
    "https://www.shogi-extend.com/"
  end

  direct :staging_app do
    "https://shogi-flow.xyz/"
  end
end
