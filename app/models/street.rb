class Street < Address
  belongs_to :ward, foreign_key: :parent_id
  has_many :lands
  include HistoryPricable
end
