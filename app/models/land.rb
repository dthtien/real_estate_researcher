class Land < ApplicationRecord
  belongs_to :street, foreign_key: :address_id
  has_many :history_prices
end
