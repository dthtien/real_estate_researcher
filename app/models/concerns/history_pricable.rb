module HistoryPricable
  extend ActiveSupport::Concern

  included do
    has_many :history_prices, through: :lands

    scope :with_history_prices, (lambda do
      select('count(history_prices.id) as history_prices_count, addresses.*')
        .joins(:history_prices)
        .order(history_prices_count: :desc)
        .group(:id)
    end)
  end
end