class LandOperations::Index
  DEFAULT_PRICE_ORDERING = ['0', '0'].freeze

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
      with_ordering addresses.first.lands
    else
      land_list = addresses.map do |address|
        with_ordering address.lands
      end.sum.reverse

      Kaminari.paginate_array(land_list)
    end
  end

  def with_ordering(lands = Land)
    lands = lands.with_history_prices if order['history_prices_count'].present?
    unless params[:price_range] == DEFAULT_PRICE_ORDERING
      price_range = (params[:price_range].first..params[:price_range].last)
      lands = lands.where(total_price: price_range)
    end

    lands.rendering(order)
  end

  def parse_lands
    if @address_names.present?
      customize_rendering.page(params[:page].to_i + 1)
    else
      with_ordering.page(params[:page].to_i + 1)
    end
  end

  def addresses
    @addresses ||= Address.where(alias_name: @address_names)
                          .or(Address.where(slug: @address_names))
  end
end
