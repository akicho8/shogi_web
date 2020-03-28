require 'rails_helper'

module Swars
  RSpec.describe type: :model do
    before do
      Swars.setup
    end

    let :user do
      User.create!
    end

    describe "to_a" do
      before do
        Battle.create! { |e| e.memberships.build(user: user) }
      end

      it do
        assert { user.user_info.medal_list.to_a == [{:method=>"tag", :name=>"居", :type=>"is-light"}, {:method=>"tag", :name=>"嬉", :type=>"is-light"}] }
      end
    end

    describe "ratio_of" do
      before do
        Battle.create!(tactic_key: "アヒル囲い") do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.ratio_of("アヒル囲い") == 1.0 }
      end
    end

    describe "deviation_avg" do
      before do
        Battle.create!(tactic_key: "アヒル囲い") do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.deviation_avg < 50.0 }
      end
    end
  end
end
