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
    opeation = AddressOperations::Show.new(params)

    render json: opeation.execute.rendering_data
  end
end
