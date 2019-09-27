class Account < ApplicationRecord
  has_secure_password

  validates_length_of :password, minimum: 6
  validates_uniqueness_of :username, :email
  validates_presence_of :username, :email

  def self.find_by_username_or_email(value)
    find_by_username(value) || find_by_email(value)
  end
end
