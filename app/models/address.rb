class Address < ApplicationRecord
  has_many :lands
  has_many :history_prices, through: :lands
end
