class LandOperations::Index
  DEFAULT_PRICE_ORDERING = ['0', '0'].freeze

  def initialize(params)
    @params = params
    @address_names = params[:address_names]
    @order = JSON.parse params[:order]
    @price_range = params[:price_range]
    @acreage_range = params[:acreage_range]
    @front_length_range = params[:front_length_range]
    @classification = params[:classifications]
    @keyword = params[:keyword]
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

  attr_reader :params, :order, :price_range, :acreage_range, :classification,
              :front_length_range, :keyword

  def customize_rendering
    if @address_names.is_a?(String) || @address_names.size == 1
      with_ordering addresses.first.lands.includes(:history_prices)
    else
      land_list = addresses.map do |address|
        with_ordering address.lands
      end.sum.reverse

      Kaminari.paginate_array(land_list)
    end
  end

  def with_ordering(scope = Land)
    scope = scope.with_history_prices if order['history_prices_count'].present?
    %i[price_range acreage_range front_length_range].each do |method_name|
      condition = method(method_name).call

      if condition.present? && condition != DEFAULT_PRICE_ORDERING
        scope = scope.send("with_#{method_name}", condition)
      end
    end

    scope = scope.with_classification(classification) if classification.present?
    scope = scope.search(keyword) if keyword.present?
    scope.rendering(order)
  end

  def parse_lands
    if @address_names.present?
      customize_rendering.page(params[:page].to_i + 1)
    else
      with_ordering(Address.first.lands)
                          .includes(:history_prices)
                          .page(params[:page].to_i + 1)
    end
  end

  def addresses
    @addresses ||= Address.where(alias_name: search_address_names)
                          .or(Address.where(slug: search_address_names))
  end

  def search_address_names
    striping_regex = /\"/

    return @address_names.gsub(striping_regex, '') if @address_names.is_a?(String)

    @address_names.map do |address_name|
      address_name.gsub(striping_regex, '')
    end
  end
end
