class ScrappingLandsJob < ApplicationJob
  PER_PAGE = 3

  def perform(offset)
    District.offset(offset).limit(PER_PAGE).find_each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
