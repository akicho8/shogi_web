module Actb
  module Seed
    extend self
    def run(options = {})
      AnsResult.setup(options)
      Season.setup(options)

      # Colosseum::User.find_each do |e|
      #   e.actb_newest_profile
      # end
    end
  end
end
