require "rails_helper"

RSpec.describe "その他", type: :system do
  it "トップ" do
    visit "http://localhost:4000/"
    expect(page).to have_content "About"
    doc_image
  end

  it "符号の鬼" do
    XyMaster.setup
    visit "http://localhost:4000/xy"
    expect(page).to have_content "符号の鬼"
    doc_image
  end

  it "実戦詰将棋" do
    TsMaster.setup
    visit "http://localhost:4000/practical-checkmate"
    expect(page).to have_content "実戦詰将棋"
    doc_image
  end

  it "目隠し詰将棋" do
    visit "http://localhost:4000/blindfold"
    expect(page).to have_content "目隠し詰将棋"
    doc_image
  end

  # it "ストップウォッチ" do
  #   visit "/stopwatch"
  #   expect(page).to have_content "Rails"
  #   doc_image
  # end

  # describe "戦法トリガー事典" do
  #   it "一覧" do
  #     visit "/tactics"
  #     expect(page).to have_content "Rails"
  #     doc_image
  #   end
  #
  #   describe "詳細" do
  #     it "囲い" do
  #       visit "/tactics/ダイヤモンド美濃"
  #       expect(page).to have_content "ダイヤモンド美濃"
  #       doc_image
  #     end
  #
  #     it "戦型" do
  #       visit "/tactics/富沢キック"
  #       expect(page).to have_content "ポンポン桂"
  #       doc_image
  #     end
  #
  #     it "手筋" do
  #       visit "/tactics/パンツを脱ぐ"
  #       expect(page).to have_content "パンツを脱ぐ"
  #       doc_image
  #     end
  #   end
  #
  #   it "戦法ツリー" do
  #     visit "/tactics-tree"
  #     expect(page).to have_content "Rails"
  #     doc_image
  #   end
end
