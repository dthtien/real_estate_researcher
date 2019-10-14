class ProvinceSerializer < ApplicationSerializer
  attributes :name, :average_price, :lands_count

  attribute :districts do |object|
    AddressGraphSerializer.new(object.districts).serializable_hash[:data]
  end
end
