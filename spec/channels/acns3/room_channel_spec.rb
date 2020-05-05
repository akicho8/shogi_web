require "rails_helper"

RSpec.describe Acns3::RoomChannel, type: :channel do
  let_it_be(:user1) { Colosseum::User.create! }
  let_it_be(:user2) { Colosseum::User.create! }

  before do
    Acns3::SchoolChannel.redis.flushdb

    stub_connection current_user: user1
  end

  let_it_be(:current_room) {
    Acns3::Room.create! do |e|
      e.memberships.build(user: user1)
      e.memberships.build(user: user2)
    end
  }

  def membership1
    current_room.memberships.find { |e| e.user == user1 }
  end

  def membership2
    current_room.memberships.find { |e| e.user == user2 }
  end

  describe "#subscribe" do
    subject do
      subscribe(room_id: current_room.id)
      subscription
    end

    it "#subscribed" do
      expect(subject).to be_confirmed
      # expect(subject).to have_stream_for(project)
    end

    it "入室" do
      assert { subject.room_users == [user1] }
    end

    it "人数通知" do
      expect { subject }.to have_broadcasted_to("acns3/school_channel").with(room_user_ids: [user1.id])
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe(room_id: current_room.id)
    end

    it "退室" do
      assert { subscription.room_users == [user1] }
      unsubscribe
      assert { subscription.room_users == [] }
    end

    it "人数通知" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/school_channel").twice
      # expect { unsubscribe }.to have_broadcasted_to("acns3/school_channel").with(room_user_ids: [])
    end

    it "切断したので負け" do
      # katimashita(:lose, :disconnect)
    end
  end

  describe "#speak" do
    before do
      subscribe(room_id: current_room.id)
    end

    it do
      subscription.speak("message" => "(message)")
      assert { user1.acns3_messages.count == 1 }
    end
  end

  describe "#progress_info_share" do
    before do
      subscribe(room_id: current_room.id)
    end

    it do
      data = { membership_id: membership1.id, quest_index: 1 }
      expect {
        subscription.progress_info_share(data)
      }.to have_broadcasted_to("acns3/room_channel/#{current_room.id}").with("progress_info_share" => {"membership_id" => membership1.id, "quest_index" => 1})

      current_room.reload
      assert { membership1.quest_index == 1 }
    end
  end

  describe "#katimasitayo" do
    before do
      subscribe(room_id: current_room.id)
    end

    it "結果画面へ" do
      expect {
        subscription.katimasitayo({})
      }.to have_broadcasted_to("acns3/room_channel/#{current_room.id}")
    end

    it "対戦中人数を減らして通知" do
      expect {
        subscription.katimasitayo({})
      }.to have_broadcasted_to("acns3/school_channel")
    end

    it "結果" do
      subscription.katimasitayo({})
      current_room.reload

      assert { current_room.end_at    }
      assert { current_room.final_key }

      assert { membership1.judge_key == "win"  }
      assert { membership2.judge_key == "lose" }

      assert { user1.reload.rating == 1516 }
      assert { user2.reload.rating == 1484 }
    end
  end
end
