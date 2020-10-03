class ServiceInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      nuxt_link_to: {name: "swars-battles"},
      title: "将棋ウォーズ棋譜検索",
      ogp_image_base: "swars-battles",
      description: "検索と言いつつそんなに検索しない",
      features: [
        "ぴよ将棋やKENTOと連携",
        "激指に転送するための棋譜コピー",
        "段級位毎の勝率表示",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/swars/histograms/attack"},
      title: "将棋ウォーズ戦法分布",
      ogp_image_base: "swars-histograms-attack",
      description: "人気のある戦法の傾向がわかる",
      features: [
        "全体だと変動しなくておもしろくないので最近のだけ出してる",
        "囲いの分布もある",
        "段級位の分布もある",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/swars/top-runner"},
      title: "将棋ウォーズイベント上位プレイヤー",
      ogp_image_base: "swars-top-runner",
      description: "勢いのあるプレイヤーがわかる",
      features: [
        "棋士団戦の期間は幽霊団員も出てきてしまう",
        "名前タップで検索できる",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/swars/professional"},
      title: "将棋ウォーズ十段の成績",
      ogp_image_base: "swars-professional",
      description: "プロの成績を覗き見る",
      features: [
        "なぜか電脳少女シロの成績もある",
        "名前タップで検索できる",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/xy"},
      title: "符号の鬼",
      ogp_image_base: "xy",
      description: "符号マスター養成所",
      features: [
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
      nuxt_link_to: {path: "/vs-clock"},
      title: "対局時計",
      new_p: false,
      ogp_image_base: "vs-clock",
      description: "チェスクロックとも言う",
      features: [
        "一般的なネット対局のプリセットを用意",
        "24の猶予時間対応",
        "フィッシャールール可",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/three-stage-leagues"},
      title: "奨励会三段リーグ成績早見表",
      ogp_image_base: "three-stage-league-players",
      description: "個人の総合成績がわかる",
      features: [
        "スマホに最適化",
        "個人毎の総成績表示",
        "在籍期間の表示",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/adapter"},
      title: "なんでも棋譜変換",
      ogp_image_base: "adapter",
      description: "混沌とした棋譜フォーマット界を正したい",
      features: [
        "変則的な将棋倶楽部24の棋譜を正規化",
        "将棋クエストのCSA形式をKIFに変換",
        "KIF・KI2・SFEN・BOD 形式の相互変換",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/share-board"},
      title: "共有将棋盤",
      ogp_image_base: "share-board",
      description: "リレー将棋や詰将棋の共有に向いている",
      features: [
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
      nuxt_link_to: {path: "/stopwatch"},
      title: "詰将棋RTA用ストップウォッチ",
      ogp_image_base: "stopwatch",
      description: "詰将棋を解く時間と正解率の計測サービス",
      features: [
        "間違えた問題だけの復習が簡単",
        "途中からの再開可",
        "問題は自分で用意してください",
        # "復習問題のリストが固定URLに入っている(のでブックマークしていれば再開が簡単)",
        # "開始と終了のタイミングで状態をブラウザに保存しているので(ブックマークしてなくても)再開が簡単",
      ],
    },
    {
      display_p: true,
      nuxt_link_to: {path: "/cpu-battle"},
      title: "CPU対戦",
      ogp_image_base: "cpu-battle",
      description: "自作の将棋AIと対戦",
      features: [
        # "コンピュータ将棋が初めて生まれたときぐらいのアリゴリズムで動作",
        # "CPUは矢倉・右四間飛車・嬉野流・アヒル戦法・振り飛車・英春流かまいたち戦法を指せます",
        "将棋に特化したプログラムであって別にAIではない",
        "見掛け倒しな矢倉や右四間飛車が指せる",
        "作者に似てめちゃくちゃ弱い",
      ],
    },
    {
      on_swars_search_p: false,
      display_p: Actb::Config[:actb_display_p],
      nuxt_link_to: {path: "/training"},
      title: "将棋トレーニングバトル",
      new_p: false,
      ogp_image_base: "training",
      description: "将棋の問題を解く力を競う対戦ゲーム",
      features: [
        "自作の問題を作れる",
        "思ったより面白くない",
        "過疎っている",
        # "自作の問題を作れる",
        # "対戦は 23:00 - 23:15 のみ",
        # "棋力アップしません",
        # "対戦→見直し→対戦のサイクルで棋力アップ(？)",
        # "ランキング上位をめざす必要はありません",
        # "アヒル戦法の誰得問題集があります",
      ],
    },
  ]
end
