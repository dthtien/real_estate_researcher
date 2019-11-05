class AddressSerializer < AddressGraphSerializer
  attribute(:name, &:show_name)

  attribute :sub_addresses do |object|
    data =
      case object.class.to_s
      when 'Province'
        object.districts.includes(:price_loggers)
      when 'District'
        object.wards.includes(:price_loggers)
      when 'Ward'
        object.streets.includes(:price_loggers)
      else
        []
      end

    if data.present?
      AddressGraphSerializer.new(
        data.with_history_prices
      ).serializable_hash[:data]
    else
      data
    end
  end
end
