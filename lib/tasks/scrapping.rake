namespace :scrapping do
  desc 'start scrappings'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  # task start: :environment do
  #   Scrapers::DistrictDetail.new.call unless Address.any?
  #   Scrapers::LandDetail.new.call
  # end

  task first_district: :environment do
    Scrapers::LandDetail.new.call_with_district(District.find(2))
    Scrapers::LandDetail.new.call_with_district(District.find(13))
    Scrapers::LandDetail.new.call_with_district(District.find(29))
    Scrapers::LandDetail.new.call_with_district(District.find(46))
    Scrapers::LandDetail.new.call_with_district(District.find(58))
    Scrapers::LandDetail.new.call_with_district(District.find(70))
  end

  task second_district: :environment do
    Scrapers::LandDetail.new.call_with_district(District.find(117))
    Scrapers::LandDetail.new.call_with_district(District.find(132))
    Scrapers::LandDetail.new.call_with_district(District.find(143))
    Scrapers::LandDetail.new.call_with_district(District.find(160))
    Scrapers::LandDetail.new.call_with_district(District.find(174))
    Scrapers::LandDetail.new.call_with_district(District.find(191))
  end

  task third_district: :environment do
    Scrapers::LandDetail.new.call_with_district(District.find(231))
    Scrapers::LandDetail.new.call_with_district(District.find(254))
    Scrapers::LandDetail.new.call_with_district(District.find(271))
    Scrapers::LandDetail.new.call_with_district(District.find(284))
    Scrapers::LandDetail.new.call_with_district(District.find(292))
    Scrapers::LandDetail.new.call_with_district(District.find(310))
  end

  task fourth_district: :environment do
    Scrapers::LandDetail.new.call_with_district(District.find(85))
    Scrapers::LandDetail.new.call_with_district(District.find(101))
    Scrapers::LandDetail.new.call_with_district(District.find(202))
    Scrapers::LandDetail.new.call_with_district(District.find(223))
    Scrapers::LandDetail.new.call_with_district(District.find(326))
    Scrapers::LandDetail.new.call_with_district(District.find(338))
  end
end
