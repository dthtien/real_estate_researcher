def parse_ratio(second_latest_number, current_number)
  second_latest_number = second_latest_number.to_i
  if second_latest_number.zero?
    1
  else
    (second_latest_number - current_number) / second_latest_number
  end
end

namespace :logging_prices do
  desc 'logging prices'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task start: :environment do
    logging = lambda do |address|
      logger = address.price_loggers.build
      logger.price = address.average_price
      logger.logged_date = Time.current
      logger.lands_count = address.lands_count
      logger.lands_count_ratio = parse_ratio(
        address.second_latest_log&.lands_count,
        logger.lands_count
      )
      logger.price_ratio = parse_ratio(
        address.second_latest_log&.price,
        logger.price
      )

      logger.save
    end

    [Province, District, Ward, Street].each do |klass|
      klass.transaction do
        klass.find_each(&logging)
      end
    end
  end
end

