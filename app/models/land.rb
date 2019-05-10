class Land < ApplicationRecord
  belongs_to :address
  has_many :history_prices
end
