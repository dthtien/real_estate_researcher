class ScrappingAddressesJob < ApplicationJob
  def perform
    Scrapers::DistrictDetail.new.call
  end
end
