#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# Actf::Question.destroy_all

# user = Colosseum::User.sysop
# params = {
#   "question" => {
#     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
#     "moves_answers"=>[{"moves_str"=>"4c5b"}],
#     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
#   },
# }.deep_symbolize_keys
#
# question = user.actf_questions.find_or_initialize_by(id: params[:question][:id])
# question.together_with_params_came_from_js_update(params)
# question
# question.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]

# lobby = Actf::LobbyChannel.new
# lobby                           # =>

#   question = user.actf_questions.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end

# user = Colosseum::User.create!
# question = user.actf_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
#   e.moves_answers.build(moves_str: "G*5b")
#   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
# end

# user = Colosseum::User.sysop
# 11.times do |i|
#   question = user.actf_questions.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end
# end
# Actf::Question.count           # => 11

# tp question
# tp question.moves_answers
# tp question.endpos_answers

# hash = question.attributes.slice("id", "user_id", "init_sfen", "time_limit_sec")
# hash                            # => {"id"=>7, "user_id"=>16, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1", "time_limit_sec"=>nil, "title"=>nil, "description"=>nil, "hint_description"=>nil, "source_desc"=>nil, "other_twitter_account"=>nil, "created_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "updated_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "o_count"=>0, "x_count"=>0}

# hash = question.attributes
# hash = hash.merge(moves_answers: question.moves_answers)
# tp hash.as_json

# Actf::Room.destroy_all

# user1 = Colosseum::User.create!
# user2 = Colosseum::User.create!
# 
# room = Actf::Room.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end

# room.messages.create!(user: user1, body: "a") # => #<Actf::Message id: 4, user_id: 19, room_id: 4, body: "a", created_at: "2020-05-05 14:45:49", updated_at: "2020-05-05 14:45:49">
# tp user1.actf_profile.update!(rating: 1600)
# tp user1.actf_profile

# def initialize(connection, identifier, params = {})
# Actf::RoomChannel.new(nil, nil, a: 1) # => 


question = Actf::Question.first
tp question.as_json(include: [:user, :moves_answers])
# >> |-----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                    id | 4                                                                                                                                                                                                                                                                     |
# >> |               user_id | 1                                                                                                                                                                                                                                                                     |
# >> |             init_sfen | 7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1                                                                                                                                                                                                                            |
# >> |        time_limit_sec | 180                                                                                                                                                                                                                                                                   |
# >> |      difficulty_level | 1                                                                                                                                                                                                                                                                     |
# >> |                 title |                                                                                                                                                                                                                                                                       |
# >> |           description |                                                                                                                                                                                                                                                                       |
# >> |      hint_description |                                                                                                                                                                                                                                                                       |
# >> |           source_desc |                                                                                                                                                                                                                                                                       |
# >> | other_twitter_account |                                                                                                                                                                                                                                                                       |
# >> |            created_at | 2020-05-09T18:53:55.512+09:00                                                                                                                                                                                                                                         |
# >> |            updated_at | 2020-05-09T18:53:55.512+09:00                                                                                                                                                                                                                                         |
# >> |   moves_answers_count | 1                                                                                                                                                                                                                                                                     |
# >> |  endpos_answers_count | 0                                                                                                                                                                                                                                                                     |
# >> |               o_count | 0                                                                                                                                                                                                                                                                     |
# >> |               x_count | 0                                                                                                                                                                                                                                                                     |
# >> |                  user | {"id"=>1, "key"=>"sysop", "name"=>"運営", "online_at"=>nil, "fighting_at"=>nil, "matching_at"=>nil, "cpu_brain_key"=>nil, "user_agent"=>"", "race_key"=>"human", "created_at"=>"2020-05-09T18:44:10.000+09:00", "updated_at"=>"2020-05-09T18:44:10.000+09:00", "em... |
# >> |         moves_answers | [{"id"=>1, "question_id"=>4, "limit_turn"=>1, "moves_str"=>"1c1b", "end_sfen"=>"7gk/8G/7G1/7N1/9/9/9/9/9 w 2r2bg4s3n4l18p 2", "created_at"=>"2020-05-09T18:53:55.577+09:00", "updated_at"=>"2020-05-09T18:53:55.577+09:00"}]                                       |
# >> |-----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
