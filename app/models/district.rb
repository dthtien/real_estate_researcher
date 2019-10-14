class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards

  def lands
    @lands ||= Land.select(
      'lands.*, COUNT(history_prices.id) history_prices_count'
    ).with_history_prices.district_relation(id)

  end

  def lands_count
    @lands_count ||= Land.district_relation(id).count
  end
end
