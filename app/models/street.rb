class Street < Address
  belongs_to :ward, foreign_key: :parent_id
  has_many :lands, foreign_key: :address_id
  include HistoryPricable
end
