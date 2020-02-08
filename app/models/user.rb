class User < ApplicationRecord
  has_many :lands

  def self.send_invite
    find_each do |user|
      return if user.email.blank?

      InviteMailMailer.invite(user).deliver_now
    end
  end
end
