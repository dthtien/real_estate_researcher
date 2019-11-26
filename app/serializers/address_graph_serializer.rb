class AddressGraphSerializer < BaseAddressSerializer
  attributes :lands_count
  attribute(:price, &:average_price)
end
