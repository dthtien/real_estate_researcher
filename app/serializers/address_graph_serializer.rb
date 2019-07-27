class AddressGraphSerializer < ApplicationSerializer
  attribute :name

  attribute :average_price do |object|
    object.avg_square_meter_price.round(0)
  end
end
