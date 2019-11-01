class MixAddressGraphSerializer < ApplicationSerializer
  attribute :children do |object|
    AddressGraphSerializer.new(object.addresses).serializable_hash[:data]
  end

  attribute :average_price do |object|
    prices = object.latest_logs.pluck(:price)
    prices.present? ? prices.sum / prices.size : 0
  end

  attribute :latest_updated_price do |object|
    object.latest_logs.first.logged_date
  end

  attribute :lands_count do |object|
    object.latest_logs.pluck(:lands_count).sum
  end

  attribute :price_ratio do |object|
    prices = object.latest_logs.pluck(:price_ratio)
    prices.present? ? 100 * prices.sum / prices.size : 0
  end

  attribute :new_lands_count do |object|
    object.addresses.map do |address|
      address.lands.new_lands_count
    end.sum
  end
end
