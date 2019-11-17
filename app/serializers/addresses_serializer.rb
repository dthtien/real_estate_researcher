class AddressesSerializer < BaseAddressSerializer
  attribute :price, &:calculating_average_price
  attribute :lands_count, &:calculating_lands_count
end
