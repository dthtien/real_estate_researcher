class PriceLogger < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  validates_uniqueness_of :logged_date, scope: %i[loggable_id loggable_type]

  scope :newest, -> { order(logged_date: :desc) }
  scope :removing_logs, (lambda do
    where('price_loggers.created_at < ?', 2.days.ago.end_of_day)
  end)

  scope :needed_fields, -> { select(:price, :lands_count, :created_at) }
end
