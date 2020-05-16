module Actf::UserMod
  concern :ClipMod do
    included do
      has_many :actf_clips, class_name: "Actf::Clip", dependent: :destroy
    end

    def clip_p(question)
      actf_clips.where(question: question).exists?
    end

    # from app/javascript/actf_app/the_history.vue
    # clip_handle(question_id: question.id, clip_p: clip_p)
    def clip_handle(params)
      question = Actf::Question.find(params[:question_id])
      clip_set(question, params[:clip_p])
    end

    private

    def clip_set(question, enable)
      s = actf_clips.where(question: question)
      if enable
        if s.exists?
          diff = 0
        else
          s.create!
          diff = 1
        end
        enable = true
      else
        if s.exists?
          s.destroy_all
          diff = -1
        else
          diff = 0
        end
        enable = false
      end
      { clip_p: enable, diff: diff }
    end
  end
end
