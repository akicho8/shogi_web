require "rails_helper"

RSpec.describe Yomiyomi::RoomChannel, type: :channel do
  before(:context) do
    Actb.setup
  end

  let(:user1) { User.create! }
  let(:room_code) { SecureRandom.hex }

  before do
    stub_connection current_user: user1
  end

  describe "#subscribe" do
    it "接続" do
      subscribe(room_code: room_code)
      assert { subscription.confirmed? }
    end
  end

  describe "#sfen_share" do
    before do
      subscribe(room_code: room_code)
    end

    it do
      data = {
        user_code: SecureRandom.hex,
        sfen: "(sfen)",
        title: "(title)",
      }
      expect {
        subscription.sfen_share(data)
      }.to have_broadcasted_to("yomiyomi/room_channel/#{room_code}").with(bc_action: "sfen_share_broadcasted", bc_params: data)
    end
  end

  describe "#title_share" do
    before do
      subscribe(room_code: room_code)
    end

    it do
      data = {
        user_code: SecureRandom.hex,
        title: "(title)",
      }
      expect {
        subscription.title_share(data)
      }.to have_broadcasted_to("yomiyomi/room_channel/#{room_code}").with(bc_action: "title_share_broadcasted", bc_params: data)
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 0.74245 seconds (files took 2.42 seconds to load)
# >> 3 examples, 0 failures
# >> 
