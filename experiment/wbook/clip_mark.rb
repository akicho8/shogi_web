require "./setup"

tp Wbook::ClipMark
# Wbook::Question.destroy_all

# user = User.sysop
# 
# question1 = user.wbook_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# question2 = user.wbook_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# 
# user.wbook_clip_marks.create!(question: question1) # => #<Wbook::ClipMark id: 32, user_id: 9, question_id: 47, created_at: "2020-06-24 11:24:33", updated_at: "2020-06-24 11:24:33">
# user.wbook_clip_marks.create!(question: question2) # =>
# 
# user.wbook_clip_marks.count      # =>

