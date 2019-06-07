class Ward < Address
  belongs_to :district, foreign_key: :parent_id
  has_many :streets, foreign_key: :parent_id
  has_many :lands, through: :streets
end
