class ProvinceSerializer < ApplicationSerializer
  attributes :name

  attribute :children do |object|
    AddressGraphSerializer.new(object.districts).serializable_hash[:data]
  end

  attribute :lands do |object|
    LandSerializer.new(
      object.lands.includes(:street).limit(10)
    ).serializable_hash[:data]
  end

  attribute :average_price do |object|
    object.latest_log.price
  end

  attribute :latest_updated_price do |object|
    object.latest_log.logged_date
  end

  attribute :lands_count do |object|
    object.latest_log.lands_count
  end

  attribute :price_ratio do |object|
    object.latest_log.price_ratio * 100
  end

  attribute :new_lands_count do |object|
    Land.new_lands_count
  end
end
