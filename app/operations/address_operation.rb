class AddressOperation
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def execute
    params[:province_name] ||= 'Ho Chi Minh'
    params[:district] ||= 'quan 1'
    params[:address] ||= 'wards'

    case params[:address]
    when 'province'
      Province.avg_square_meter_prices
    else
      province = District.find_by(alias_name: params[:district])
      province.wards.avg_square_meter_prices.to_a
    end
  end
end
