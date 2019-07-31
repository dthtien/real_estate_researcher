class Address < ApplicationRecord
  extend FriendlyId
  friendly_id :alias_name

  scope :avg_square_meter_prices, -> do
    joins(:lands)
      .select('
        addresses.id,
        addresses.name,
        addresses.slug,
        (AVG(lands.total_price)::decimal / NULLIF(AVG(lands.acreage),0))
          as avg_square_meter_price')
      .group('addresses.name, addresses.id, addresses.slug')
  end

  def average_price
    price = lands.select(
              '(AVG(lands.total_price)::decimal / AVG(lands.acreage))
                as average_price'
            )[0].average_price
    price.present? ? price.round(0) : 0.0
  end

  def show_name
    return "#{name}, #{district.name}" if self.class == Ward

    name
  end
end
