class Ward < Address
  belongs_to :district, foreign_key: :parent_id
  has_many :streets, foreign_key: :parent_id
  has_many :lands, through: :streets
  has_many :history_prices, through: :lands

  scope :with_history_prices, (lambda do
    select('count(history_prices.id) as history_prices_count, addresses.*')
      .joins(:history_prices)
      .order(history_prices_count: :desc)
      .group(:id)
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
