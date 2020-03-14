class Addresses::PriceLogger
  def call
    Address.find_each do |address|
      address.land_only_price = address.lands.land_only_price
      address.apartment_price = address.lands.apartment_price
      address.house_price = address.lands.house_price
      address.farm_price = address.lands.farm_price
      address.lands_count = address.lands.count
      address.save
    end
  end
end
