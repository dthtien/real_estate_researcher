class ScrappingLandsJob < ApplicationJob
  PER_PAGE = 2

  def perform(offset)
    District.sort_by_created_at(offset, PER_PAGE).find_each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
