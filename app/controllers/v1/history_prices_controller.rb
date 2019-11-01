class V1::HistoryPricesController < ApplicationController
  def index
    history_prices = HistoryPrice.where(land_id: land.id)
                                 .needed_fields
                                 .ordering(params)
    history_prices_with_pagination = history_prices.page(params[:page])

    render json: {
      history_prices: history_prices_with_pagination.as_json,
      total_count: history_prices_with_pagination.total_count,
      max_total_price: history_prices.maximum(:total_price),
      min_total_price: history_prices.calculatable.minimum(:total_price)
    }
  end

  private

  def land
    @land ||= Land.find_by_slug(params[:land_id])
  end
end
