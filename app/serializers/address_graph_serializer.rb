class AddressGraphSerializer < ApplicationSerializer
  attribute :name, :slug, :lands_count

  attribute :average_price do |object|
    object.average_price.to_f.round(0)
  end
end
