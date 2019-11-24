class PriceLogger < ApplicationRecord
  belongs_to :loggable, polymorphic: true

  scope :newest, -> { order(logged_date: :desc) }
  scope :removing_logs, (lambda do
    where('price_loggers.created_at < ?', 2.days.ago.end_of_day)
  end)
end
