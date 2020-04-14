module Acns2
  class Message < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    with_options presence: true do
      validates :body
    end

    after_create_commit do
      MessageBroadcastJob.perform_later(self)
    end
  end
end
