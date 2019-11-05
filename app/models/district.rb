class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards
  has_many :lands, through: :streets
  has_many :history_prices, through: :lands

  scope :with_history_prices, (lambda do
    select('count(history_prices.id) as history_prices_count, addresses.*')
      .joins(:history_prices)
      .order(history_prices_count: :desc)
      .group(:id)
  end)

  def lands
    @lands ||= Land.district_relation(id)
  end

  def top_fluctuate_lands
    @top_fluctuate_lands ||= Land.top_fluctuate.district_relation(id)
  end

  def lands_count
    @lands_count ||= Land.district_relation(id).count
  end
end
