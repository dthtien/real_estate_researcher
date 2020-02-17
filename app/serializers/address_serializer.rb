class AddressSerializer < AddressesSerializer
  attribute(:name, &:show_name)

  attribute :land_only_price do |object|
    object.lands.land_only_price
  end

  attribute :apartment_price do |object|
    object.lands.apartment_price
  end

  attribute :farm_price do |object|
    object.lands.farm_price
  end

  attribute :house_price do |object|
    object.lands.house_price
  end

  attribute :sub_addresses do |object, params|
    data =
      case object.class.to_s
      when 'Province'
        object.districts
      when 'District'
        object.wards
      when 'Ward'
        object.streets
      else
        []
      end
    if data.present?
      data = data.includes(:price_loggers).calculatable
      data = data.ordering(params) if params.present?
      AddressGraphSerializer.new(data).serializable_hash[:data]
    else
      data
    end
  end
end
