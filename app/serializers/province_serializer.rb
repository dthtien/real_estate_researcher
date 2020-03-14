class ProvinceSerializer < ApplicationSerializer
  attributes :name, :land_only_price, :apartment_price, :house_price,
             :farm_price, :lands_count

  attribute :children do |object, params|
    districts = object.districts
    districts = districts.ordering(params) if params.present?

    AddressGraphSerializer.new(districts).serializable_hash[:data]
  end

  attribute :latest_updated_price do |object|
    Time.current.strftime('%d/%m/%Y')
  end

  attribute :price_ratio do |object|
    latest_log = object.latest_log

    if latest_log.present?
      old_price = latest_log.price
      old_price.zero? ? 100 * (object.calculating_average_price - old_price) / old_price : 0
    else
      100
    end
  end

  attribute :new_lands_count do |object|
    object.lands.new_lands_count
  end
end
