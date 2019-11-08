class Lands::Corrector
  INFINITY_PRICE_ACC = 156
  def call
    Land.where('square_meter_price != ? AND square_meter_price > ?',
               Land.find(INFINITY_PRICE_ACC).square_meter_price,
               10**9).each do |land|
      land.total_price /= 1000
      land.square_meter_price /= 1000
      land.save
    end
  end
end
