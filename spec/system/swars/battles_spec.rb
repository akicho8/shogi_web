require "rails_helper"

RSpec.describe "将棋ウォーズ棋譜検索", type: :system do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "トップ" do
    visit "/w"
    expect(page).to have_content "将棋ウォーズ棋譜検索"
    expect(page).to have_field "query"
    doc_image
  end

  it "検索" do
    visit "/w"
    fill_in "query", with: "hanairobiyori"
    click_button "検索"
    expect(page).to have_content "対戦相手"
    doc_image
  end

  it "検索を連打と仮定" do
    visit "/w?query=hanairobiyori&slow_processing=1"
    expect(page).to have_content "データ収集中なのであと15秒ぐらいしてからお試しください"
    doc_image
  end

  it "戦法クラウド" do
    visit "/w-cloud"
    expect(page).to have_content "Rails"
    doc_image
  end
end
