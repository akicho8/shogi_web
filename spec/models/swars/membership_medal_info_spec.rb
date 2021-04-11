require 'rails_helper'

module Swars
  RSpec.describe MembershipMedalInfo, type: :model do
    before do
      Swars.setup
    end

    describe "タグ依存メダル" do
      def test(tactic_keys, win_or_lose)
        black = User.create!
        white = User.create!
        tactic_keys.each do |e|
          Battle.create!(tactic_key: e) do |e|
            e.memberships.build(user: black, judge_key: win_or_lose)
            e.memberships.build(user: white)
          end
        end
        {black: black, white: white}.inject({}) { |a, (k, v)|
          a.merge(k => v.memberships.first.first_matched_medal.key.to_s)
        }
      end

      def b(*tactic_keys)
        test(tactic_keys, :win)[:black]
      end

      def w(*tactic_keys)
        test(tactic_keys, :lose)[:white]
      end

      it do
        assert { b("角不成")   == "角不成マン"   }
        assert { b("飛車不成") == "飛車不成マン" }
        assert { b("背水の陣") == "背水マン"     }
      end
    end

    describe "切断マン" do
      def csa_seq_generate(n)
        [["+5958OU", 600], ["-5152OU", 600], ["+5859OU", 600], ["-5251OU", 600]].cycle.take(n)
      end

      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        assert { test1(13) != [:切断マン, "悔しかったので切断した"] }
        assert { test1(14) == [:切断マン, "悔しかったので切断した"] }
      end
    end

    describe "絶対投了しないマン" do
      def csa_seq_generate(n)
        [["+5958OU", 599], ["-5152OU", 599], ["+5859OU", 599], ["-5251OU", 599]].cycle.take(n)
      end

      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message == [:絶対投了しないマン, "悔しかったので時間切れになるまで9分59秒放置した"]
      end

      it do
        assert { !test1(13) }
        assert { test1(14) }
        assert { test1(15) }
      end
    end

    describe "1手詰じらしマン" do
      def test1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test1                   # => [:"1手詰じらしマン", "1手詰を9分58秒焦らして歪んだ優越感に浸った"]
        assert { test1 == [:"1手詰じらしマン", "1手詰を9分58秒焦らして歪んだ優越感に浸った"] }
      end
    end

    describe "長考" do
      def test(min)
        seconds = min.minutes

        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test(2.5)             # => [:長考マン, "考えすぎて負けた。ちなみに一番長かったのは2分30秒"]
        test(3.0)             # => [:大長考マン, "対局放棄に近い、ありえないほどの長考をした。ちなみに3分"]
        assert { test(2.5) == [:長考マン, "考えすぎて負けた。ちなみに一番長かったのは2分30秒"] }
        assert { test(3.0) == [:大長考マン, "対局放棄と受け取られてもおかしくない3分の長考をした"] }
      end
    end

    describe "ただの千日手" do
      def csa_seq_generate(n)
        [["+5958OU", 600], ["-5152OU", 600], ["+5859OU", 600], ["-5251OU", 600]] * n
      end

      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :DRAW_SENNICHI) do |e|
          e.memberships.build(user: @black, judge_key: :draw)
          e.memberships.build(user: @white, judge_key: :draw)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test(4)                 # => [:ただの千日手, "千日手"]
        test(3)                 # => [:開幕千日手, "最初から千日手にした"]
        assert { test(4) == [:ただの千日手, "千日手"]             }
        assert { test(3) == [:開幕千日手, "最初から千日手にした"] }
      end
    end

    describe "切れ負けマン" do
      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - i * 30.seconds
          [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds], ["-5251OU", seconds]]
        end
      end

      def test1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(20), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test1                   # => [:切れ負けマン, "時間切れで負けた"]
        assert { test1 == [:切れ負けマン, "時間切れで負けた"] }
      end
    end

    describe "棋神マン" do
      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - (i * 4.seconds)
          [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds - 2], ["-5251OU", seconds]]
        end
      end

      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test(20)                # => [:棋神マン, "棋神召喚疑惑あり"]
        assert { test(20) == [:棋神マン, "棋神召喚疑惑あり"] }
      end
    end

    describe "段級差" do
      def test1(*keys)
        Battle.create! { |e|
          keys.each do |key|
            e.memberships.build(user: User.create!(grade: Grade.find_by(key: key)))
          end
        }.memberships.collect { |e| e.medal_params[:message] }
      end

      it "全パターン" do
        test1("30級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("12級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("11級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("10級", "1級") # => ["9つも格上の人を倒した", "9つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "9級", "1級") # => ["8つも格上の人を倒した", "8つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "8級", "1級") # => ["7つも格上の人を倒した", "7つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "7級", "1級") # => ["6つも格上の人を倒した", "6つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "6級", "1級") # => ["5つも格上の人を倒した", "5つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "5級", "1級") # => ["4つも格上の人を倒した", "4つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "4級", "1級") # => ["3つも格上の人を倒した", "3つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "3級", "1級") # => ["2つも格上の人を倒した", "2つも格下の人に、勝ってあたりまえなのに、負けた"]
        test1( "2級", "1級") # => ["格上のライバルを倒した", "1つ格下の人に負けた"]
        test1( "1級", "1級") # => ["ライバルに勝った", "ライバルに負けた"]
        test1("初段", "1級") # => ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"]
        test1("二段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("三段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("四段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("五段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("六段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("七段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("八段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("九段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]
        test1("十段", "1級") # => ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"]

        assert {  test1("30級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("12級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("11級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("10級", "1級") == ["9つも格上の人を倒した", "9つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "9級", "1級") == ["8つも格上の人を倒した", "8つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "8級", "1級") == ["7つも格上の人を倒した", "7つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "7級", "1級") == ["6つも格上の人を倒した", "6つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "6級", "1級") == ["5つも格上の人を倒した", "5つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "5級", "1級") == ["4つも格上の人を倒した", "4つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "4級", "1級") == ["3つも格上の人を倒した", "3つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "3級", "1級") == ["2つも格上の人を倒した", "2つも格下の人に、勝ってあたりまえなのに、負けた"] }
        assert {  test1( "2級", "1級") == ["格上のライバルを倒した", "1つ格下の人に負けた"] }
        assert {  test1( "1級", "1級") == ["ライバルに勝った", "ライバルに負けた"] }
        assert {  test1("初段", "1級") == ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"] }
        assert {  test1("二段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("三段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("四段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("五段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("六段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("七段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("八段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("九段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
        assert {  test1("十段", "1級") == ["格下の人にあたりまえのように勝った", "格上の人にあたりまえのように負けた"] }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .........
# >>
# >> Finished in 12.15 seconds (files took 2.68 seconds to load)
# >> 9 examples, 0 failures
# >>
