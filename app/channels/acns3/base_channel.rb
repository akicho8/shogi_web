module Acns3
  class BaseChannel < ApplicationCable::Channel
    delegate :redis, to: "self.class"

    def self.redis
      @redis ||= Redis.new(db: AppConfig[:redis_db_for_acns3])
    end

    def room_user_ids
      redis.smembers(:room_user_ids).collect(&:to_i)
    end
  end
end
