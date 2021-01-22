require 'rails_helper'

module Wkbk
  RSpec.describe Qgenerator, type: :model do
    include WkbkSupportMethods

    before do
      article1
    end

    it "works" do
      RuleInfo.each do |rule_info|
        assert { Qgenerator.new(rule_info: rule_info, users: [user1, user2]).generate }
      end
    end

    it "出題調整" do
      Wkbk::Article.destroy_all
      a_articles = 2.times.collect { user1.wkbk_articles.create_mock1 } # A
      b_articles = 2.times.collect { user1.wkbk_articles.create_mock1 } # B

      # B だけ履歴作成
      b_articles.each do |e|
        user1.wkbk_histories.create!(article: e, ox_mark: OxMark.fetch("correct"))
        user1.wkbk_histories.create!(article: e, ox_mark: OxMark.fetch("correct"))
      end

      users = [user1, user2]
      Qgenerator.new.history_latest_articles.to_sql # => "SELECT `wkbk_histories`.* FROM `wkbk_histories` WHERE `wkbk_histories`.`ox_mark_id` = 1 GROUP BY `wkbk_histories`.`article_id` ORDER BY MAX(created_at) DESC LIMIT 100"
      Qgenerator.new.history_latest_articles.pluck(:article_id)    # => [826, 827]

      # B は含まれていない
      ids1 = Qgenerator.new(rule_info: RuleInfo[:test_rule], users: users, fill: false).generate.collect(&:id).sort
      ids1                             # => [824, 825]
      ids2 = a_articles.collect(&:id) # => [824, 825]
      assert { ids1 == ids2 }

      # fill: true なら補完している
      ids1 = Qgenerator.new(rule_info: RuleInfo[:test_rule], users: users, fill: true).generate.collect(&:id).sort
      ids1                                                  # => [824, 825, 826, 827]
      ids2 = (a_articles + b_articles).collect(&:id).sort # => [824, 825, 826, 827]
      assert { ids1 == ids2 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.95 seconds (files took 2.13 seconds to load)
# >> 2 examples, 0 failures
# >> 
