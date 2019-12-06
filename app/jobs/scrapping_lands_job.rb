class ScrappingLandsJob < ApplicationJob
  queue_as :critical

  def perform(district_ids)
    District.where(id: district_ids).each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
