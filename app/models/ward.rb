class Ward < Address
  belongs_to :district, foreign_key: :parent_id
  has_many :streets, foreign_key: :parent_id
  has_many :lands, through: :streets
  include HistoryPricable

  scope :not_finish, (lambda do
    where(finish: false).order(:total_page)
  end)

  def update_total_page!(page_count)
    if persisted? && total_page != page_count
      self.finish = false
      self.scrapping_page = 0
    end
    self.total_page = page_count

    save!
  end
end
