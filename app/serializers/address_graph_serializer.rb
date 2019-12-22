class AddressGraphSerializer < BaseAddressSerializer
  attribute :lands_count

  attribute(:price, &:average_price)
end
