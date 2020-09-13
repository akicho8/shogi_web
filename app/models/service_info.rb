class ServiceInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      link_path: [:swars, :battles],
      title: "将棋ウォーズ棋譜検索",
      image_source: "swars_battles_index.png",
      description: "直近の対局の検討することを目的とした棋譜取得サービス",
      feature_items: [
        "<b>ぴよ将棋</b>や<b>KENTO</b>と連携",
        "<b>激指</b>に転送するための棋譜コピー",
        "対戦相手の段級位毎の勝率表示",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/vs-clock"),
      title: "対局時計",
      new_p: false,
      image_source: "ogp/vs-clock.png",
      description: "チェスクロック買うのがもったいないので作った",
      feature_items: [
        "一般的なネット対局のプリセットを用意",
        "24の猶予時間対応",
        "フィッシャールール可",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/xy"),
      title: "符号の鬼",
      image_source: "ogp/xy.png",
      description: "符号マスター養成所",
      feature_items: [
        "タップするルールはスマホ用",
        # "キーボードで入力するルールはPC用",
        "100問正解するまでの時間を競う",
        "1分半切ったら卒業",
        # "先後両方の視点で練習可",
        # "ランキングあり",
        # "キーボードで入力するルールはパソコン用",
      ],
    },
    {
      display_p: true,
      link_path: FrontendScript::ThreeStageLeagueScript.script_link_path,
      title: "三段リーグ成績早見表",
      image_source: [
        "frontend_script/three_stage_league_script_1200x630.png",
        "frontend_script/three_stage_league_player_script_1200x630.png",
      ],
      description: "成績が一目でわかるサービス",
      feature_items: [
        "スマホに最適化",
        "個人毎の成績表示",
        "在籍期間の表示",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/adapter"),
      title: "なんでも棋譜変換",
      image_source: "ogp/adapter.png",
      description: "多種多様な棋譜形式を正規化するサービス",
      feature_items: [
        "<b>将棋倶楽部24</b>や<b>将棋クエスト</b>の棋譜を正規化",
        "<b>KENTO</b>や<b>将棋DB2</b>のURLを棋譜化",
        "KIF・KI2・SFEN・BOD 形式の相互変換",
        # "「ぴよ将棋」や「KENTO」に橋渡し",
        # "棋譜共有(ツイートできる)",
        # "特定局面の画像化",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/share-board"),
      title: "共有将棋盤",
      image_source: "ogp/share-board.png",
      description: "リレー将棋などを目的としたサービス",
      feature_items: [
        "SNS等での指し継ぎ",
        "課題局面や詰将棋の作成",
        "オンライン対局向けのリアルタイム盤共有",
        # "URLをTwitter等のSNSに貼ると局面画像が現れる",
        # "URLから訪れた人は指し継げる (駒を動かしながら詰将棋が解ける)",
        # "棋譜や視点の情報はすべてURLに含まれている",
        # "そのため分岐しても前の状態に影響を与えない",
        # "部屋を立てるとリアルタイムに盤面を共有する",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/stopwatch"),
      title: "詰将棋RTA用ストップウォッチ",
      image_source: "ogp/stopwatch.png",
      description: "詰将棋を解く時間と正解率の計測サービス",
      feature_items: [
        "間違えた問題だけの復習が簡単",
        "途中からの再開可",
        "問題は自分で用意してください",
        # "復習問題のリストが固定URLに入っている(のでブックマークしていれば再開が簡単)",
        # "開始と終了のタイミングで状態をブラウザに保存しているので(ブックマークしてなくても)再開が簡単",
      ],
    },
    {
      display_p: true,
      link_path: UrlProxy.wrap("/cpu-battle"),
      title: "CPU対戦",
      image_source: "ogp/cpu-battle.png",
      description: "自作の将棋AIと対戦",
      feature_items: [
        # "コンピュータ将棋が初めて生まれたときぐらいのアリゴリズムで動作",
        # "CPUは矢倉・右四間飛車・嬉野流・アヒル戦法・振り飛車・英春流かまいたち戦法を指せます",
        "将棋に特化したプログラムであってAIではない",
        "矢倉や右四間飛車が指せる",
        "作者に似てめちゃくちゃ弱い",
      ],
    },
    {
      on_swars_search_p: false,
      display_p: Actb::Config[:actb_display_p],
      link_path: [:training],
      title: "将棋トレーニングバトル！",
      new_p: false,
      image_source: [
        "frontend_script/actb_app_script1_1200x630.png",
        "frontend_script/actb_app_script2_1200x630.png",
        # "frontend_script/actb_app_script3_1200x630.png",
      ],
      description: "将棋の問題を解く力を競う対戦ゲーム",
      feature_items: [
        "詰将棋以外の問題もある",
        "自作の問題を作れる",
        "過疎っている",
        # "自作の問題を作れる",
        # "対戦は <b>23:00 - 23:15</b> のみ",
        # "棋力アップしません",
        # "対戦→見直し→対戦のサイクルで棋力アップ(？)",
        # "ランキング上位をめざす必要はありません",
        # "アヒル戦法の誰得問題集があります",
      ],
    },
  ]
end
