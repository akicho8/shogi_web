class FixDefaultPassowrdIsPassword < ActiveRecord::Migration[5.2]
  def change
    Colosseum::User.all.each do |user|
      if user.valid_password?("password")
        user.password = Devise.friendly_token(32)
        user.save! if Rails.env.production?
        p user.name
      end
    end
    Colosseum::User.all.each do |user|
      if user.valid_password?("password")
        raise if Rails.env.production?
      end
    end
    Colosseum::User.sysop.update!(password: Rails.application.credentials.sysop_password)
  end
end
