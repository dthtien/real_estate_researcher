class AddressSerializer < AddressesSerializer
  attribute(:name, &:show_name)

  attribute :land_only_price, :apartment_price, :farm_price, :house_price

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
      data = data.includes(:price_loggers)
      data = data.ordering(params) if params.present?
      AddressGraphSerializer.new(data).serializable_hash[:data]
    else
      data
    end
  end
end
