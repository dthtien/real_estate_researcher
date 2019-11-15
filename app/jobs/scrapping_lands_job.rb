class ScrappingLandsJob < ApplicationJob
  def perform(order = 'desc')
    District.order(created_at: order).find_each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end
end
