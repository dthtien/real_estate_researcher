class Lands::Corrector
  def call
    Land.where('expired_date < ?', Date.current).destroy_all

    Land.where('square_meter_price != ? AND square_meter_price > ?',
               Float::INFINITY, 10**9).each do |land|
      land.total_price /= 1000
      land.square_meter_price /= 1000
      land.save
    end

    Land.where('total_price < ? and total_price != 0', 10**8).each do |land|
      total_price = land.total_price
      increase_rate = 10 - total_price.to_i.to_s.size

      land.total_price = total_price * 10**increase_rate
      land.square_meter_price *= 10**increase_rate
      land.save
    end
  end
end
