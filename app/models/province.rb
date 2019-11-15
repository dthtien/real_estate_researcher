class Province < Address
  has_many :districts, foreign_key: :parent_id
  has_many :wards, through: :districts
  has_many :streets, through: :wards
  has_many :lands, through: :streets

  def lands
    @lands ||= Land.province_relation(id)
  end

  def lands_count
    @lands_count ||= Land.province_relation(id).count
  end
end
