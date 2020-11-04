module Emox
  module UserMod
    module ClipMod
      extend ActiveSupport::Concern

      included do
        has_many :emox_clip_marks, class_name: "::Emox::ClipMark", dependent: :destroy
      end

      def clip_p(question)
        emox_clip_marks.where(question: question).exists?
      end

      # from app/javascript/emox_app/the_history.vue
      def clip_handle(params)
        question = Question.find(params[:question_id])
        if params[:enabled].nil?
          enabled = !clip_p(question)
        else
          enabled = params[:enabled]
        end
        {
          question_id: question.id,
          clip: clip_set(question, enabled),
        }
      end

      private

      def clip_set(question, enabled)
        s = emox_clip_marks.where(question: question)
        if enabled
          if s.exists?
            diff = 0
          else
            s.create!
            diff = 1
          end
          enabled = true
        else
          if s.exists?
            s.destroy_all
            diff = -1
          else
            diff = 0
          end
          enabled = false
        end
        {
          enabled: enabled,                        # 現在の状態
          diff: diff,                              # 前回との差分
          count: question.reload.clip_marks_count, # ビューでは未使用→使用
        }
      end
    end
  end
end
