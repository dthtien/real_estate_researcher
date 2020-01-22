class LandOperations::Index
  DEFAULT_PRICE_ORDERING = ['0', '0'].freeze

  def initialize(params)
    @params = params
    @address_names = params[:address_names]
    @order = JSON.parse params[:order]
    @price_range = params[:price_range]
    @acreage_range = params[:acreage_range]
  end

  def rendering_lands
    @rendering_lands ||= LandSerializer.new(lands).serializable_hash[:data]
  end

  def lands
    @lands ||= parse_lands
  end

  def lands_count
    lands.total_count
  end

  private

  attr_reader :params, :order, :price_range, :acreage_range

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

    if price_range.present? && price_range != DEFAULT_PRICE_ORDERING
      lands = lands.with_total_price(price_range)
    end

    if acreage_range.present? && acreage_range != DEFAULT_PRICE_ORDERING
      lands = lands.with_acreage(acreage_range)
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
