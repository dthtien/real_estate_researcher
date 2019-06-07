class Address < ApplicationRecord
  scope :avg_square_meter_prices, -> do
    joins(:lands)
      .select('addresses.name,
        (AVG(lands.total_price)::decimal / AVG(lands.acreage))
          as avg_square_meter_price')
      .group('addresses.name')
  end
end
