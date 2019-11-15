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
    LoggingPriceJob.perform_later
  end
end

