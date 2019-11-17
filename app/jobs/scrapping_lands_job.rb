class ScrappingLandsJob < ApplicationJob
  DESC_SORT = 'desc'.freeze

  def perform(order = DESC_SORT)
    districts = District.all
    scrapping = lambda do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end

    districts = districts.reverse if order != DESC_SORT

    districts.each(&scrapping)
  end
end
