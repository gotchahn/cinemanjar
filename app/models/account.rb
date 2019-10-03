class Account < ApplicationRecord
  has_secure_password

  validates_length_of :password, minimum: 6
  validates_uniqueness_of :username, :email
  validates_presence_of :username, :email

  has_one :address
  belongs_to :favorite_cinema

  accepts_nested_attributes_for :address, allow_destroy: true

  def self.find_by_username_or_email(value)
    find_by_username(value) || find_by_email(value)
  end

  def favorite_cinema_name
    if favorite_cinema
      favorite_cinema.name
    else
      "N/A"
    end
  end

  def favorite_genres_msg
    if favorite_genres.any?
      favorite_genres.join(", ")
    else
      "You haven't picked any movie yet"
    end
  end
end
