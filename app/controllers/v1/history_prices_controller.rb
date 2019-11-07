class V1::HistoryPricesController < ApplicationController
  def index
    render json: HistoryPriceOperations::Index.new(params).call
  end
end
