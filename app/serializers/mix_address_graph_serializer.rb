class MixAddressGraphSerializer < ApplicationSerializer
  attributes :average_price, :slug

  attribute(:name, &:show_name)
end
