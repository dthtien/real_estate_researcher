class ScrappingAddressesJob < ApplicationJob
  def perform
    Scrapers::BdsScrappers::DistrictDetail.new.call
  end
end
