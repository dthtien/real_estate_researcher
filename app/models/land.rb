class Land < ApplicationRecord
  belongs_to :street, foreign_key: :address_id
  has_many :history_prices
  has_one :ward, through: :street
  has_one :district, through: :ward
  scope :district_relation, -> { joins(:district) }
end
