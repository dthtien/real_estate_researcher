class HistoryPrice < ApplicationRecord
  belongs_to :land

  scope :needed_fields, (lambda do
    select(:total_price, :posted_date, :square_meter_price, :id)
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
