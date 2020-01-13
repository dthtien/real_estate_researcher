class V1::PriceLoggersController < ApplicationController
  def index
    price_loggers = address.price_loggers
                           .needed_fields
                           .page(params[:page].to_i + 1)
    render json: {
      price_loggers: PriceLoggerSerializer.new(price_loggers).serializable_hash,
      count: price_loggers.total_count
    }
  end

  private

  def address
    @address ||= Address.find_by_slug(params[:address_id])
  end
end
