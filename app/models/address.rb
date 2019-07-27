class Address < ApplicationRecord
  scope :avg_square_meter_prices, -> do
    joins(:lands)
      .select('addresses.name,
        (AVG(lands.total_price)::decimal / AVG(lands.acreage))
          as avg_square_meter_price')
      .group('addresses.name')
  end

  def average_price
    price = lands.select(
              '(AVG(lands.total_price)::decimal / AVG(lands.acreage))
                as average_price'
            )[0].average_price
    price.present? ? price.round(0) : 0.0
  end

  def show_name
    return "#{name} #{district.name}" if self.class == Ward

    name
  end
end
