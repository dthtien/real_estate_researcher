class AddressSerializer < ApplicationSerializer
  attributes :average_price, :slug

  attribute(:name, &:show_name)
  attribute :land_counts do |object|
    object.lands.count
  end

  attribute :sub_addresses do |object|
    if object.class == Province
      MixAddressGraphSerializer.new(object.districts).serializable_hash[:data]
    else
      data = object.wards.avg_square_meter_prices if object.class == District
      data = object.streets.avg_square_meter_prices if object.class == Ward

      AddressGraphSerializer.new(data).serializable_hash[:data]
    end
  end
end
