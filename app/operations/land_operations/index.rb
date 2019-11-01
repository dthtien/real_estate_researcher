class LandOperations::Index
  def initialize(params)
    @params = params
    @address_names = params[:address_names]
  end

  def rendering_lands
    @rendering_lands ||= LandSerializer.new(lands).serializable_hash[:data]
  end

  def lands
    @lands ||= parse_lands
  end

  private

  attr_reader :params

  def customize_rendering
    if @address_names.size == 1
      addresses.first.lands.with_history_prices
    else
      land_list = addresses.map do |address|
        address.lands.with_history_prices
      end.sum.sort_by(&:history_prices_count).reverse

      Kaminari.paginate_array(land_list)
    end
  end

  def parse_lands
    parse_lands =
      if @address_names.present?
        customize_rendering
      else
        Land.includes(:street)
            .with_history_prices
      end

    parse_lands.page(params[:page])
  end

  def addresses
    @addresses ||= Address.where(alias_name: @address_names)
                          .or(Address.where(slug: @address_names))
  end
end
