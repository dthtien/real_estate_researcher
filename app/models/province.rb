class Province < Address
  has_many :districts, foreign_key: :parent_id
  has_many :wards, through: :districts
  has_many :streets, through: :wards

  def lands
    @lands ||= Land.with_history_prices.province_relation(id)
  end

  def lands_count
    @lands_count ||= Land.province_relation(id).count
  end
end
