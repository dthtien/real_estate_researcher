class HistoryPriceOperations::Index
  def initialize(params)
    @params = params
  end

  def call
    {
      history_prices: history_prices_paginating.as_json,
      total_count: history_prices_paginating.total_count,
      max_total_price: highest_price,
      min_total_price: lowest_price
    }
  end

  private

  attr_reader :params

  def history_prices
    @history_prices ||= land.history_prices.needed_fields.ordering(params)
  end

  def history_prices_paginating
    @history_prices_paginating ||= history_prices.page(params[:page])
  end

  def land
    @land ||= Land.find_by_slug(params[:land_id])
  end

  def highest_price
    maximum = history_prices.maximum(:total_price)
    maximum > land.total_price ? maximum : land.total_price
  end

  def lowest_price
    minimum = history_prices.calculatable.minimum(:total_price)
    minimum < land.total_price ? minimum : land.total_price
  end
end
