class LandOperations::Index
  def initialize(params)
    @params = params
    @address_names = params[:address_names]
    @order = JSON.parse params[:order]
  end

  def rendering_lands
    @rendering_lands ||= LandSerializer.new(lands).serializable_hash[:data]
  end

  def lands
    @lands ||= parse_lands
  end

  private

  attr_reader :params, :order

  def customize_rendering
    if @address_names.size == 1
      with_ordering addresses.first.lands.with_history_prices
    else
      land_list = addresses.map do |address|
        with_ordering address.lands.with_history_prices
      end.sum.sort_by(&:history_prices_count).reverse

      Kaminari.paginate_array(land_list)
    end
  end

  def with_ordering(lands)
    lands = order.present? ? lands.ordering(order) : lands
    lands.includes(:street)
  end

  def parse_lands
    parse_lands =
      if @address_names.present?
        customize_rendering
      else
        with_ordering Land.with_history_prices
      end

    parse_lands.page(params[:page].to_i + 1)
  end

  def addresses
    @addresses ||= Address.where(alias_name: @address_names)
                          .or(Address.where(slug: @address_names))
  end
end
