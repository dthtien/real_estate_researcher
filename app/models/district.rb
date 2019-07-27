class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards
  has_many :lands, through: :streets, foreign_key: :address_id
end
