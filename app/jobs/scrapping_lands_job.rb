class ScrappingLandsJob < ApplicationJob
  def perform(offset)
    District.offset(offset).limit(3).find_each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
