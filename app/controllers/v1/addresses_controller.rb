class V1::AddressesController < ApplicationController
  def index
    addresses = AddressOperation.new(params).execute
    render json: AddressGraphSerializer.new(addresses)
                                       .serializable_hash
  end
end
