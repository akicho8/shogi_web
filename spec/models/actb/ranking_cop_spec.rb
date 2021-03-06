require 'rails_helper'

module Actb
  RSpec.describe RankingCop, type: :model do
    include ActbSupportMethods

    def test1(rating)
      user = User.create!(name: "(#{rating})")
      user.actb_season_xrecord.update!(rating: rating, battle_count: 1)
      user
    end

    it do
      user1 = test1(15)
      user2 = test1(14)
      user3 = test1(13)

      ranking_cop = Actb::RankingCop.new(ranking_key: :rating, current_user: user3, max: 1)
      retv = ranking_cop.as_json

      assert { retv["current_user_rank_record"]["rank"] == 3 }
      assert { retv["rank_records"].size == 1                }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.56924 seconds (files took 2.14 seconds to load)
# >> 1 example, 0 failures
# >> 
