class AddressGraphSerializer < ApplicationSerializer
  attribute :name, :slug

  attribute :average_price do |object|
    object.avg_square_meter_price.to_f.round(0)
  end
end
