class V1::UsersController < ApplicationController

  before_action :set_land
  def show
    render json: user_data
  end

  private

  def user_data
    if @land.user.present?
      UserSerializer.new(@land.user).serializable_hash[:data]
    else
      {}
    end
  end

  def set_land
    @land = Land.includes(:user).find_by(slug: params[:land_id])
  end
end
