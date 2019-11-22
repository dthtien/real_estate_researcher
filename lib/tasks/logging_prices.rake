namespace :logging_prices do
  desc 'logging prices'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task start: :environment do
    LoggingPriceJob.perform_later
  end
end

