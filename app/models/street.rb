class Street < Address
  belongs_to :ward, foreign_key: :parent_id
  has_many :lands, foreign_key: :address_id
  has_many :history_prices, through: :lands

  scope :with_history_prices, (lambda do
    select('count(history_prices.id) as history_prices_count, addresses.*')
      .joins(:history_prices)
      .order(history_prices_count: :desc)
      .group(:id)
  end)
end
