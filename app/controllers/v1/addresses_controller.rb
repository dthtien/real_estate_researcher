class V1::AddressesController < ApplicationController
  def index
    opeation = AddressOperations::Index.new(params).execute
    render json: opeation.parsed_addresses
  end

  def address_names
    data = Address.search_by_name(params[:q]).limit(10)

    render json: AddressSuggestionSerializer.new(data).serializable_hash
  end

  def show
    address = Address.includes(:price_loggers).find_by_slug(params[:id])

    render json: AddressSerializer.new(address,
                                       params: JSON.parse(params[:order]))
                                  .serializable_hash
  end
end
