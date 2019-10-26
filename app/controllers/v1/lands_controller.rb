class V1::LandsController < ApplicationController
  before_action :set_lands, only: :index

  def index
    render json: {
      lands: LandSerializer.new(@lands).serializable_hash,
      total_count: @lands.total_count
    }
  end

  def show
    land = Land.find_by_slug(params[:id])
    render json: LandDetailsSerializer.new(land).serializable_hash
  end

  private

  def set_lands
    address = Address.find_by_slug(params[:address_id])
    lands = address.lands
    lands = lands.top_fluctuate if address.is_a?(Ward) || address.is_a?(Street)
    @lands = lands.page(params[:page].to_i + 1)
  end
end
