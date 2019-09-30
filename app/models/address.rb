class Address < ApplicationRecord
  belongs_to :account

  validates_presence_of :city
  geocoded_by :full_address

  def full_address
    address1 = [street, apt_number].join(" ")
    state_postal = [state, postal_code].join(" ")
    [address1, city, state_postal].join(", ")
  end
end
