class HistoryPrice < ApplicationRecord
  belongs_to :land

  validates_uniqueness_of :total_price, scope: %i[acreage land_id]

  scope :needed_fields, (lambda do
    uniqueness_informations
      .select(:total_price, :posted_date, :square_meter_price, :id)
  end)

  scope :uniqueness_informations, (lambda do
    select('
      DISTINCT ON (history_prices.total_price, history_prices.acreage,
        history_prices.land_id
      ) "history_prices"."id"
    ')
  end)

  scope :calculatable, (lambda do
    where('history_prices.total_price > 0')
  end)

  scope :ordering, (lambda do |params|
    order(
      posted_date: params[:posted_date],
      total_price: params[:total_price]
    )
  end)
end
