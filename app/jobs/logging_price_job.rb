class LoggingPriceJob < ApplicationJob
  def perform
    Address.find_each do |address|
      save_log! address
    end
  end

  private

  def save_log!(address)
    logger = address.price_loggers.build
    average_price = address.calculating_average_price
    logger.price = average_price.is_a?(Numeric) ? average_price : 0
    logger.logged_date = Time.current
    logger.lands_count = address.calculating_lands_count
    logger.save
  end
end
