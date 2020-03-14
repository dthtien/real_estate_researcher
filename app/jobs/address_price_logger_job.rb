class AddressPriceLoggerJob < ApplicationJob
  def perform
    Addresses::PriceLogger.new.call
    GC.start
  end
end
