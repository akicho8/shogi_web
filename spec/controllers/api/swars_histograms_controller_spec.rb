require "rails_helper"

RSpec.describe Api::SwarsHistogramsController, type: :controller do
  def test1(key)
    get :show, params: {key: :attack}
    value = JSON.parse(response.body, symbolize_names: true)
    value                       # => {:updated_at=>"2020-09-22T18:09:42.871+09:00", :tactic=>{:key=>"attack", :name=>"戦型", :code=>1}, :tactics=>[{:key=>"defense", :name=>"囲い", :code=>0}, {:key=>"attack", :name=>"戦型", :code=>1}, {:key=>"technique", :name=>"手筋", :code=>2}, {:key=>"note", :name=>"備考", :code=>3}], :records=>[{:name=>"カメレオン戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"脇システム", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"矢倉棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"森下システム", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"雀刺し", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"米長流急戦矢倉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"カニカニ銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"カニカニ金", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"中原流急戦矢倉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"阿久津流急戦矢倉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"矢倉中飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"右四間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"原始棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"右玉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"かまいたち戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"英春流カメレオン", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"パックマン戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"新米長玉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"稲庭戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"四手角", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"一間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"一間飛車穴熊", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"都成流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"右四間飛車左美濃", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角換わり", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角換わり腰掛け銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角換わり棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角換わり早繰り銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"筋違い角", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"相筋違い角", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"木村定跡", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"一手損角換わり", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"相掛かり", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"相掛かり棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"塚田スペシャル", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"中原流相掛かり", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"中原飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"腰掛け銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"鎖鎌銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"８五飛車戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"UFO銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"横歩取り", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"△３三角型空中戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"△３三桂戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"△２三歩戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"△４五角戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"相横歩取り", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"ゴキゲン中飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"ツノ銀中飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"平目", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"風車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"新風車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"英ちゃん流中飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"原始中飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"加藤流袖飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"５七金戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"超急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"中飛車左穴熊", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"遠山流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"四間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"耀龍四間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"藤井システム", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"立石流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"レグスペ", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"三間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"石田流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"早石田", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"升田式石田流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"鬼殺し", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"2手目△３ニ飛戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"中田功XP", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"真部流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"▲７八飛戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"４→３戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"楠本式石田流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"新石田流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"新鬼殺し", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"ダイレクト向かい飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"向かい飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"メリケン向かい飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"阪田流向飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角頭歩戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"鬼殺し向かい飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"陽動振り飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"玉頭銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"つくつくぼうし戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"ひねり飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"耀龍ひねり飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"相振り飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"角交換振り飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"きｍきｍ金", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"ポンポン桂", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"５筋位取り", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"玉頭位取り", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"地下鉄飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"飯島流引き角戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"丸山ワクチン", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"新丸山ワクチン", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"４六銀左急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"４五歩早仕掛け", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"鷺宮定跡", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"４六銀右急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"左美濃急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"右四間飛車急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"鳥刺し", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"嬉野流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"メイドシステム", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"棒金", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"棒玉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"超速", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"対振り持久戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"高田流左玉", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"７二飛亜急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"袖飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"一直線穴熊", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"穴角戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"穴角向かい飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"うっかり三間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"菅井流三間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"アヒル戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"裏アヒル戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"矢倉左美濃急戦", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"青野流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"勇気流", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"極限早繰り銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"トマホーク", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"羽生式袖飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"初手７八銀戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"初手３六歩戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"きんとうん戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"魔界四間飛車", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"目くらまし戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"端棒銀", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"金銀橋", :count=>0, :deviation_score=>nil, :ratio=>nil}, {:name=>"３七銀戦法", :count=>0, :deviation_score=>nil, :ratio=>nil}], :sample_count=>0}
    assert { value[:updated_at] }
    assert { response.status == 200 }
  end

  it "works" do
    test1(:grade)
    test1(:defense)
    test1(:attack)
    test1(:technique)
    test1(:note)
  end
end
