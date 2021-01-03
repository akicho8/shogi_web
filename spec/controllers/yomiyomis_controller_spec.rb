require 'rails_helper'

RSpec.describe YomiyomisController, type: :controller do
  it "HTMLの要求はNuxt側にリダイレクト" do
    get :show, params: { }
    expect(response).to have_http_status(:redirect)
  end

  describe "基本「58玉」" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5h", turn:1, title: "(title)", format: format }
      expect(response).to have_http_status(:ok)
    end
    it "works" do
      test("png")
      test("kif")
      test("ki2")
      test("sfen")
      test("csa")
    end
  end

  describe "エラーの場合" do
    def test(format)
      get :show, params: { body: "position startpos moves 5i5e", format: format }
      expect(response).to have_http_status(:ok)
    end
    it do
      test("png")
      test("kif")
    end
  end

  describe "「初手55歩」は歩を持ってないためエラー" do
    def test(format)
      get :show, params: { body: "position startpos moves P*5e", format: format }
    end
    it do
      test("png")
      expect(response).to have_http_status(422)
    end
  end

  it "IDではなく棋譜がキーになっている" do
    2.times { get :show, params: { body: "position startpos moves 7g7f", format: "json" } }
    assert { FreeBattle.count == 1 }
  end

  it "Twitterカードに戦法名が出る" do
    get :show, params: { body: "68銀", format: "json" }
    assert { controller.twitter_card_options[:description] == "☗嬉野流 vs ☖その他" }
  end

  it "Twitterカード用の画像パス" do
    get :show, params: { body: "68銀", abstract_viewpoint: "white", format: "json" }
    assert { controller.current_og_image_path == "/share-board.png?abstract_viewpoint=white&body=position+startpos+moves+7i6h&title=%E5%85%B1%E6%9C%89%E5%B0%86%E6%A3%8B%E7%9B%A4&turn=1" }
  end

  it "abstract_viewpoint の値がおかしいときにエラーにしない" do
    get :show, params: { body: "68銀", abstract_viewpoint: "xxxx", format: "json" }
    expect(response).to have_http_status(:ok)
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...F....
# >> 
# >> Failures:
# >> 
# >>   1) YomiyomisController Twitterカード用の画像パス
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:57:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >> 
# >> Finished in 1.23 seconds (files took 3.74 seconds to load)
# >> 8 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:54 # YomiyomisController Twitterカード用の画像パス
# >> 
