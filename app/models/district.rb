class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards

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
