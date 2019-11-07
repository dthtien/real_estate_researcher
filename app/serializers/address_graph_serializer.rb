class AddressGraphSerializer < ApplicationSerializer
  attributes :name, :slug, :logged_date, :alias_name, :lands_count

  attribute(:price, &:average_price)

  attribute :price_ratio do |object|
    calculate_ratio(:price, object.latest_log, object.average_price)
  end

  attribute :lands_count_ratio do |object|
    calculate_ratio(:lands_count, object.latest_log, object.lands_count)
  end

  class << self
    private

    def calculate_ratio(field, log, new_value)
      if log.present?
        old_value = log.send(field)
        old_value.zero? ? 0 : (new_value - old_value) / old_value
      else
        1
      end
    end
  end
end
