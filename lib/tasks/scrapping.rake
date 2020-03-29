namespace :scrapping do
  desc 'start scrappings'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task first: :environment do
    District.order(created_at: 'asc').each do |district|
      Scrapers::BdsScrappers::LandDetail.new.call_with_district(district)
    end
  end

  task second: :environment do
    District.order(created_at: 'desc').each do |district|
      Scrapers::BdsScrappers::LandDetail.new.call_with_district(district)
    end
  end

  task third: :environment do
    District.left_joins(:lands)
            .having('COUNT(lands.id) = 0')
            .group(:id)
            .each do |district|
      Scrapers::BdsScrappers::LandDetail.new.call_with_district(district)
    end
  end
end
