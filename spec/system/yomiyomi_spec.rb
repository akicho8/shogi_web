require "rails_helper"

RSpec.describe "共有将棋盤", type: :system do
  it "最初" do
    visit "http://localhost:4000/share-board"
    expect(page).to have_content "共有将棋盤"
    doc_image
  end

  it "駒落ちで開始したとき△側が下に来ている" do
    visit "http://localhost:4000/share-board?body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0&title=%E6%8C%87%E3%81%97%E7%B6%99%E3%81%8E%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B"
    assert_selector(".CustomShogiPlayer .is_viewpoint_white")
    doc_image
  end
end
