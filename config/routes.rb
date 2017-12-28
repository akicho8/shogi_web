Rails.application.routes.draw do
  root "resource_ns1/battle_records#index"

  ################################################################################ 2ch棋譜検索

  namespace :resource_ns1, path: "" do
    resources :general_battle_users
    resources :general_battle_records, path: "sr" do
      resources :tag_cloud, :only => :index, :module => :general_battle_records
    end
    resources :general_battle_ships

    get "s/:query", to: "general_battle_records#index", as: :general_search
    get "s",        to: "general_battle_records#index"
    get "s-cloud",  to: "general_battle_records/tag_cloud#index", as: :general_cloud
  end

  resolve "GeneralBattleUser" do |general_battle_user, options|
    resource_ns1_general_search_path(query: general_battle_user.to_param)
  end

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :resource_ns1, path: "" do
    resources :battle_users
    resources :battle_records, path: "wr" do
      resources :tag_cloud, :only => :index, :module => :battle_records
    end
    resources :battle_ships

    get "w/:query", to: "battle_records#index", as: :swars_search
    get "w",        to: "battle_records#index"
    get "w-cloud",  to: "battle_records/tag_cloud#index", as: :swars_cloud
  end

  resolve "BattleUser" do |battle_user, options|
    resource_ns1_swars_search_path(query: battle_user.to_param)
  end

  ################################################################################ 棋譜変換

  namespace :resource_ns1, path: "" do
    resources :free_battle_records, path: "x"
  end

  resolve "FreeBattleRecord" do |free_battle_record, options|
    [:resource_ns1, free_battle_record, options]
  end

  ################################################################################ 戦法トリガー辞典

  resources :formation_articles, path: "tactics"

  get "tactics-tree",   to: "formation_articles#index", defaults: {mode: "tree"}, as: :tree
  get "tactics-fortune", to: "formation_articles#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号入力ゲーム

  get "xy", to: "xy_game#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |battle_record|
    "http://kif-pona.heroz.jp/games/#{battle_record.battle_key}?locale=ja"
  end

  direct :mountain_upload do
    "http://shogi-s.com/upload-text"
  end

  direct :piyo_shogi_app do |url|
    "piyoshogi://?url=#{url}"
  end
end
