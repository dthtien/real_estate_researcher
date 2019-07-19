class V1::AddressesController < ApplicationController
  def index
    addresses = AddressOperation.new(params).execute
    render json: AddressGraphSerializer.new(addresses)
                                      .serializable_hash

  end
  def address_names
    data = Address.where('alias_name iLIKE ?', "%#{params[:q]}%").limit(10)
    render json: AddressSuggestionSerializer.new(data).serializable_hash
  end
end
