class V1::LandsController < ApplicationController
  def index
    operation = LandOperations::Index.new(params)

    render json: {
      lands: operation.rendering_lands
    }
  end

  def show
    land = Land.with_street_name.find_by_slug(params[:id])

    render json: LandDetailsSerializer.new(land).serializable_hash
  end
end
