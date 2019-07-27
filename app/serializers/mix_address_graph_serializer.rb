class MixAddressGraphSerializer < ApplicationSerializer
  attributes :average_price

  attribute :name do |object|
    object.show_name
  end
end
