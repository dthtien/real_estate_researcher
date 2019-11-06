class AddressGraphSerializer < ApplicationSerializer
  attribute :name, :slug, :price, :logged_date, :lands_count_ratio,
            :price_ratio, :alias_name

  attribute :lands_count do |object|
    object.latest_log&.lands_count
  end
end
