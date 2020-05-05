#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# Acns3::Question.destroy_all

# user = Colosseum::User.sysop
# params = {
#   "question" => {
#     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
#     "moves_answers"=>[{"moves_str"=>"4c5b"}],
#     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
#   },
# }.deep_symbolize_keys
#
# question = user.acns3_questions.find_or_initialize_by(id: params[:question][:id])
# question.together_with_params_came_from_js_update(params)
# question
# question.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]

# lobby = Acns3::LobbyChannel.new
# lobby                           # =>

#   question = user.acns3_questions.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end

# user = Colosseum::User.create!
# question = user.acns3_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
#   e.moves_answers.build(moves_str: "G*5b")
#   e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
# end

# user = Colosseum::User.sysop
# 11.times do |i|
#   question = user.acns3_questions.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(sfen_endpos: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end
# end
# Acns3::Question.count           # => 11

# tp question
# tp question.moves_answers
# tp question.endpos_answers

# hash = question.attributes.slice("id", "user_id", "init_sfen", "time_limit_sec")
# hash                            # => {"id"=>7, "user_id"=>16, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1", "time_limit_sec"=>nil, "title"=>nil, "description"=>nil, "hint_description"=>nil, "source_desc"=>nil, "other_twitter_account"=>nil, "created_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "updated_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "o_count"=>0, "x_count"=>0}

# hash = question.attributes
# hash = hash.merge(moves_answers: question.moves_answers)
# tp hash.as_json

# Acns3::Room.destroy_all

user1 = Colosseum::User.create!
user2 = Colosseum::User.create!

room = Acns3::Room.create! do |e|
  e.memberships.build(user: user1, judge_key: "win")
  e.memberships.build(user: user2, judge_key: "lose")
end

# room.messages.create!(user: user1, body: "a") # => #<Acns3::Message id: 4, user_id: 19, room_id: 4, body: "a", created_at: "2020-05-05 14:45:49", updated_at: "2020-05-05 14:45:49">
# tp user1.acns3_profile.update!(rating: 1600)
# tp user1.acns3_profile

# def initialize(connection, identifier, params = {})
# Acns3::RoomChannel.new(nil, nil, a: 1) # => 

# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/actioncable-6.0.2.2/lib/action_cable/channel/base.rb:249:in `delegate_connection_identifiers': undefined method `identifiers' for nil:NilClass (NoMethodError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/actioncable-6.0.2.2/lib/action_cable/channel/base.rb:158:in `initialize'
# ~> 	from -:74:in `new'
# ~> 	from -:74:in `<main>'
