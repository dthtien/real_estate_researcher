class V1::LandsController < ApplicationController
  def index
    address = Address.find_by_slug(params[:address_id])
    lands = address.lands.top_fluctuate.page(params[:page].to_i + 1)

    render json: {
      lands: LandSerializer.new(lands).serializable_hash,
      total_count: lands.total_count
    }
  end

  def show
    land = Land.find_by_slug(params[:id])

    render json: LandDetailsSerializer.new(land).serializable_hash
  end
end
