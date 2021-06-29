class ServiceInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {name: "swars-search"},
      title: "将棋ウォーズ棋譜検索",
      og_image_key: "swars-search",
      description: "他のアプリで検討したいときにどうぞ",
      features: [
        "ぴよ将棋や KENTO で検討できる",
        "激指や ShogiGUI にはコピーして張り付け (CTRL+V)",
        "プレイヤー戦力分析機能付き",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/xy"},
      title: "符号の鬼",
      attention_label: "UPDATE!",
      og_image_key: "xy",
      description: "符号マスター養成所",
      features: [
        "100問正解するまでの時間を競う",
        "1分半切ったら卒業",
        "棋書を読むのが楽になるかもしれない",
      ],
    },
    {
      display_p: true, # !Rails.env.production?,
      experiment_p: false,
      nuxt_link_to: {path: "/vs"},
      title: "対人戦",
      attention_label: "NEW!",
      og_image_key: "share-board-vs",
      description: "気軽に対局したいときにどうぞ",
      features: [
        "プレイ人数 1〜8人",
        "いまんところはログイン不要",
        "これは共有将棋盤の「自動マッチング」へのショートカット",
      ],
    },
    {
      key: :wkbk,
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/rack"},
      title: "インスタント将棋問題集",
      attention_label: nil,
      og_image_key: "rack",
      # description: "市販の問題集を繰り返し解くよりも、最初のうちは本人のために本人の実戦譜の検討を元に本人が作った問題集を繰り返し解いた方が身に付きやすいのではないか、という実験もかねた、将棋問題投稿復習ツール",
      # description: "本人が本人のために作る問題集を解いた方がためになるのではないかと考えて作った問題集作成ツール",
      # description: "本人が本人のために作る問題集作成ツール",
      description: "検討を問題集化して繰り返し解きたいときにどうぞ",
      features: [
        # "問題はデフォルトでは非公開です",
        # "公開している問題集に入れたときだけ問題は他の人にも見られます",
        # "問題集は公開すると他の人も解けるけど基本「非公開」でよい",
        # "非公開の問題は投稿者以外からは絶対にアクセスできない",
        # "ｳｫｰｽﾞの検討結果を問題にしておくのおすすめ",
        # "将棋ｳｫｰｽﾞの対局から問題作成するときは検索後の対局詳細にある問題作成からインポートできる",
        # "対戦の検討を問題化して本人専用問題集を作ることを想定",
        "本人が本人のために作る問題集エディタ",
        "「問題」を作って「問題集」に入れる",
        "Youtubeと同じような公開設定機能あり",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/share-board"},
      title: "共有将棋盤",
      attention_label: "UPDATE!",
      og_image_key: "share-board",
      description: "リレー将棋・詰将棋作成・仲間内での対戦にどうぞ",
      features: [
        "SNS等にURLを貼って指し継ぐ時間無制限のリレー将棋",
        "部屋を立ててリアルタイム盤面共有・対戦 (時計設置可)",
        "課題局面や詰将棋の作成・公開・共有",
        # "URLをTwitter等のSNSに貼ると局面画像が現れる",
        # "URLから訪れた人は指し継げる (駒を動かしながら詰将棋が解ける)",
        # "棋譜や視点の情報はすべてURLに含まれている",
        # "そのため分岐しても前の状態に影響を与えない",
        # "部屋を立てるとリアルタイムに盤面を共有する",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/adapter"},
      title: "なんでも棋譜変換",
      og_image_key: "adapter",
      description: "棋譜が読み込めないときに放り込もう",
      features: [
        "変則的な将棋倶楽部24の棋譜を正規化",
        "将棋クエストのCSA形式をKIFに変換",
        "KIF・KI2・SFEN・BOD 形式の相互変換",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/stopwatch"},
      title: "詰将棋用ストップウォッチ",
      og_image_key: "stopwatch",
      description: "正解率や速度を見える化したいときにどうぞ",
      features: [
        "間違えた問題だけの復習が簡単",
        "途中からの再開が簡単",
        "問題は自分で用意してください",
        # "復習問題のリストが固定URLに入っている(のでブックマークしていれば再開が簡単)",
        # "開始と終了のタイミングで状態をブラウザに保存しているので(ブックマークしてなくても)再開が簡単",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/swars/histograms/attack"},
      title: "将棋ウォーズ戦法分布",
      og_image_key: "swars-histograms-attack",
      description: "人気戦法を知りたいときにどうぞ",
      features: [
        "変動するように最近のだけ出してる",
        "囲いや段級位の分布もある",
        "人気戦法の対策をすれば勝ちやすいかも？",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/swars/top-group"},
      title: "将棋ウォーズイベント上位の成績",
      og_image_key: "swars-top-group",
      description: "上位プレイヤーの棋譜を見たいときにどうぞ",
      features: [
        "現在開催中のイベントが対象",
        "名前タップで棋譜検索",
        "「─」は引き分け",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/swars/professional"},
      title: "将棋ウォーズ十段の成績",
      og_image_key: "swars-professional",
      description: "プロの棋譜を見たいときにどうぞ",
      features: [
        "名前タップで棋譜検索",
        "先生方がほとんどだが野生の十段もいる",
        "なぜか電脳少女シロもいる",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/three-stage-leagues"},
      title: "奨励会三段リーグ成績早見表",
      og_image_key: "three-stage-league-players",
      description: "個人成績を見たいときにどうぞ",
      features: [
        "スマホに最適化",
        "個人毎の総成績表示",
        "在籍期間の表示",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/cpu-battle"},
      title: "CPU対戦",
      og_image_key: "cpu-battle",
      description: "ネット将棋で心をやられたときにどうぞ",
      features: [
        "自作の将棋AI",
        "見掛け倒しな戦法を指す",
        "作者に似てめちゃくちゃ弱い",
        # "コンピュータ将棋が初めて生まれたときぐらいのアリゴリズムで動いている",
        # # "CPUは矢倉・右四間飛車・嬉野流・アヒル戦法・振り飛車・英春流かまいたち戦法を指せます",
        # "将棋に特化したプログラムであって別にAIではない",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/vs-clock"},
      title: "対局時計",
      attention_label: nil,
      og_image_key: "vs-clock",
      description: "大会などで時計が足りないときにどうぞ",
      features: [
        "一般的なネット対局のプリセットを用意",
        "将棋倶楽部24の猶予時間に対応",
        "フィッシャールール対応",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: {path: "/style-editor"},
      title: "将棋盤スタイルエディタ",
      attention_label: nil,
      og_image_key: "style-editor",
      description: "将棋盤のスタイルをいじくる開発用ツール",
      features: [
        "もともとは将棋盤の動作テスト用に作ったものですが他の用途にも使えそうなので公開しています",
        "これで加工した画面は自由に使ってもらってかまいません",
      ],
    },
    {
      display_p: Emox::Config[:emox_display_p],
      experiment_p: true,
      nuxt_link_to: {path: "/emoshogi"},
      title: "エモ将棋",
      attention_label: nil,
      og_image_key: "emox",
      description: "気持ちを伝えながら指す実験的ネット将棋",
      features: [
        "フッターにある字を押して気持ちを伝える",
        "いろいろアレなんで匿名",
      ],
    },
    {
      display_p: Actb::Config[:actb_display_p],
      experiment_p: true,
      nuxt_link_to: {path: "/training"},
      title: "将棋トレーニングバトル",
      attention_label: nil,
      og_image_key: "actb",
      description: "将棋の問題を解く力を競うネット対戦ゲーム",
      features: [
        "自作の問題を作れる",
        "問題投稿＆共有したいときは「インスタンス将棋問題集」の方をどうぞ",
        # "アヒル戦法の誰得問題集がある",
        # "面白いかと思って作ったらあんまり面白くなかった",
        # "詰将棋の著作権に対しての価値観の違いからくるわだかまりのみを残し終了……(笑)"
        # "対戦は 23:00 - 23:15 のみ",
        # "棋力アップしません",
        # "対戦→見直し→対戦のサイクルで棋力アップ(？)",
        # "ランキング上位をめざす必要はありません",
      ],
    },
    {
      display_p: true,
      experiment_p: true,
      nuxt_link_to: {path: "/practical-checkmate"},
      title: "実戦詰将棋『一期一会』",
      attention_label: nil,
      og_image_key: "practical-checkmate",
      description: "やねうら王の詰将棋500万問からﾗﾝﾀﾞﾑに出題",
      features: [
        "一度出会った問題には二度と会えないかも",
        "初見力が試される",
        "作意がないぶん逆にむずい！？",
      ],
    },
    {
      display_p: true,
      experiment_p: true,
      nuxt_link_to: {path: "/blindfold"},
      title: "目隠し詰将棋",
      attention_label: nil,
      og_image_key: "blindfold",
      description: "声を聞いて脳内で将棋盤を作って解く<s>苦行</s>練習",
      features: [
        "試作なので最低限の機能のみ",
      ],
    },
  ]

  def og_meta
    [:title, :description, :og_image_key].inject({}) {|a, e| a.merge(e => public_send(e)) }
  end
end
