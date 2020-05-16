module Actf
  class History < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"
    belongs_to :question
    belongs_to :ans_result

    # room と membership ない方がいいか検討
    # room と membership はビューでまったく使ってない
    belongs_to :room
    belongs_to :membership

    before_validation do
      if membership
        self.room ||= membership.room
        self.user ||= membership.user
      end
      self.ans_result ||= AnsResult.fetch(:mistake)
    end

    def good_p
      user.actf_good_marks.where(question: question).exists?
    end

    def bad_p
      user.actf_bad_marks.where(question: question).exists?
    end

    def clip_p
      user.actf_clips.where(question: question).exists?
    end
  end
end
