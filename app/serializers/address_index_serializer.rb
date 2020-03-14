class AddressIndexSerializer < ApplicationSerializer
  attribute :children do |object|
    AddressesSerializer.new(object.addresses).serializable_hash[:data]
  end

  attribute :land_only_price do |object|
    avg_price = object.addresses.map(&:land_only_price).sum
    avg_price / object.addresses.size
  end

  attribute :apartment_price do |object|
    avg_price = object.addresses.map(&:apartment_price).sum
    avg_price / object.addresses.size
  end

  attribute :house_price do |object|
    avg_price = object.addresses.map(&:house_price).sum
    avg_price / object.addresses.size
  end

  attribute :farm_price do |object|
    avg_price = object.addresses.map(&:farm_price).sum
    avg_price / object.addresses.size
  end

  attribute :latest_updated_price do
    Time.current.strftime('%d/%m/%Y')
  end

  attribute :lands_count do |object|
    object.addresses.map(&:lands_count).compact.sum
  end

  attribute :new_lands_count do |object|
    object.addresses.map do |address|
      address.lands_count
    end.sum
  end
end
