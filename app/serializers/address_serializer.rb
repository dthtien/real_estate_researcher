class AddressSerializer < AddressesSerializer
  attribute(:name, &:show_name)

  attribute :price_ratio do |object|
    calculate_ratio(:price, object.latest_log, object.calculating_average_price)
  end

  attribute :lands_count_ratio do |object|
    calculate_ratio(:lands_count, object.latest_log, object.calculating_lands_count)
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

  class << self
    private

    def calculate_ratio(field, log, new_value)
      if log.present?
        old_value = log.send(field)
        value = old_value.zero? ? 0 : (new_value - old_value) / old_value
        value.round(2)
      else
        1
      end
    end
  end
end
