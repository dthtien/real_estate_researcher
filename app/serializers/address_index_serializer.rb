class AddressIndexSerializer < ApplicationSerializer
  attribute :children do |object|
    AddressesSerializer.new(object.addresses).serializable_hash[:data]
  end

  attribute :average_price do |object|
    avg_price = object.addresses.map(&:calculating_average_price).sum
    avg_price / object.addresses.size
  end

  attribute :latest_updated_price do
    Time.current.strftime('%d/%m/%Y')
  end

  attribute :lands_count do |object|
    object.addresses.map(&:calculating_lands_count).sum
  end

  attribute :new_lands_count do |object|
    object.addresses.map do |address|
      address.lands.new_lands_count
    end.sum
  end
end
