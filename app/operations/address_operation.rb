class AddressOperation
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def execute
    params[:province_name] ||= 'Ho Chi Minh'
    params[:address] ||= 'wards'

    case params[:address]
    when 'province'
      Province.avg_square_meter_prices
    else
      province = Province.find_by(alias_name: params[:province_name])
      province.wards.avg_square_meter_prices.to_a
    end
  end
end
