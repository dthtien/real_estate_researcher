class LoggingPriceJob < ApplicationJob
  def perform
    [Province, District, Ward, Street].each do |klass|
      klass.transaction do
        klass.find_each do |address|
          address.price_loggers.removing_logs.delete_all
          save_log! address
        end
      end
    end
  end

  private

  def save_log!(address)
    logger = address.price_loggers.build
    logger.price = address.calculating_average_price
    logger.logged_date = Time.current
    logger.lands_count = address.calculating_lands_count

    logger.save
  end
end