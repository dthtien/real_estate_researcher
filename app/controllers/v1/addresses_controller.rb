class V1::AddressesController < ApplicationController
  def index
    opeation = AddressOperations::Index.new(params).execute
    render json: opeation.addresses
  end

  def address_names
    data = Address.where(
      'alias_name iLIKE ? OR name iLIKE ?', "%#{params[:q]}%", "%#{params[:q]}%"
    ).limit(10)
    render json: AddressSuggestionSerializer.new(data).serializable_hash
  end
end
