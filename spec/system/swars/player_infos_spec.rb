require "rails_helper"

RSpec.describe "将棋ウォーズプレイヤー情報", type: :system do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "成功" do
    visit "/w-user-stat?user_key=hanairobiyori"
    expect(page).to have_content "Rails"
    doc_image
  end

  it "連打したと仮定" do
    visit "/w-user-stat?user_key=hanairobiyori&slow_processing=1"
    expect(page).to have_content "データ収集中なのであと15秒ぐらいしてからお試しください"
    doc_image
  end
end
