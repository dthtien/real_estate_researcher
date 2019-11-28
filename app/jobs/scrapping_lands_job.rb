class ScrappingLandsJob < ApplicationJob
  LIMIT = 8

  def perform(offset = 0)
    District.offset(offset).limit(LIMIT).each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
