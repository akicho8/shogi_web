require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

Actb::Lineage.all.collect(&:key)                 # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
Actb::Judge.all.collect(&:key)                   # => ["win", "lose", "draw", "pending"]

10.times do
  Actb::Season.create!
end

# tp Actb.info

user1 = Colosseum::User.sysop
user2 = Colosseum::User.find_or_create_by!(key: "alice")

Colosseum::User.setup
# 8.times do |e|
#   Colosseum::User.create!
# end

# 問題作成
3.times do |i|
  question = user1.actb_questions.create! do |e|
    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.time_limit_sec        = 60 * 3
    e.difficulty_level      = 5
    e.title                 = "(title)"
    e.description           = "(description)"
    e.hint_description      = "(hint_description)"
    e.source_desc           = "(source_desc)"
    e.other_twitter_account = "(other_twitter_account)"
  end
end
Actb::Question.count           # => 3

question = Actb::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 714, user_id: 238, type: "Actb::TrashBox", created_at: "2020-05-30 04:11:08", updated_at: "2020-05-30 04:11:08">

# 2番目の問題は下書きへ
question = Actb::Question.second!
question.folder_key           # => "active"
question.folder_key = :draft
question.save!                 # => true
question.folder.type           # => "Actb::DraftBox"
# tp question.as_json
# exit

# 部屋を立てる
room = Actb::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

room.users.collect(&:name)                      # => ["運営", "名無しの棋士2号"]

# 対戦を作成
battle = room.battles.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
battle                          # => #<Actb::Battle id: 20, room_id: 17, parent_id: nil, begin_at: "2020-05-30 04:11:10", end_at: nil, final_key: nil, rule_key: "marathon_rule", rensen_index: 0, created_at: "2020-05-30 04:11:10", updated_at: "2020-05-30 04:11:10">

battle.users.count                # => 2
battle.rensen_index               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 21, room_id: 17, parent_id: 20, begin_at: "2020-05-30 04:11:10", end_at: nil, final_key: nil, rule_key: "marathon_rule", rensen_index: 1, created_at: "2020-05-30 04:11:10", updated_at: "2020-05-30 04:11:10">
battle2.rensen_index                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>51, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_description"=>"(hint_description)", "source_desc"=>"(source_desc)", "other_twitter_account"=>"(other_twitter_account)", "user"=>{"id"=>238, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ox_mark_key = Actb::OxMarkInfo[i.modulo(Actb::OxMarkInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(ox_mark_key))
end

# 終局
battle.katimashita(user1, :win, :all_clear)
tp user1.actb_newest_xrecord

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# 問題に対してコメント
5.times do
  question = Actb::Question.first!
  question.messages.create!(user: user1, body: "message") # => 
  question.messages_count                    # => 
end

tp Actb::Question

tp Actb.info
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.2.2/lib/active_model/attribute_methods.rb:431:in `method_missing': undefined method `judge_key=' for #<Actb::BattleMembership:0x00007ff536be6968> (NoMethodError)
# ~> Did you mean?  judge_id=
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/battle.rb:94:in `block in katimashita'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/database_statements.rb:281:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/monitor.rb:235:in `mon_synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/connection_adapters/abstract/database_statements.rb:281:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.2.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/battle.rb:90:in `katimashita'
# ~> 	from -:97:in `<main>'
