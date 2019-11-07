class LoggingPriceJob < ApplicationJob
  def perform
    logging = lambda do |address|
      logger = address.price_loggers.build
      logger.price = address.average_price
      logger.logged_date = Time.current
      logger.lands_count = address.lands_count

      logger.save
    end

    [Province, District, Ward, Street].each do |klass|
      klass.transaction do
        klass.find_each do |address|
          save_log! address
        end
      end
    end
  end

  private

  def save_log!(address)
    logger = address.price_loggers.build
    logger.price = address.average_price
    logger.logged_date = Time.current
    logger.lands_count = address.lands_count

    logger.save
  end
end