class ProvinceSerializer < ApplicationSerializer
  attributes :name, :lands_count

  attribute :children do |object, params|
    districts = object.districts.includes(:price_loggers).calculatable
    districts = districts.ordering(params) if params.present?

    AddressGraphSerializer.new(districts).serializable_hash[:data]
  end

  attribute :latest_updated_price do |object|
    object.latest_log.logged_date
  end

  attribute :average_price, &:calculating_average_price

  attribute :price_ratio do |object|
    latest_log = object.latest_log

    if latest_log.present?
      old_price = latest_log.price
      old_price.zero? ? 100 * (object.average_price - old_price) / old_price : 0
    else
      100
    end
  end

  attribute :new_lands_count do
    Land.new_lands_count
  end
end
