namespace :scrapping do
  desc 'start scrappings'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task start: :environment do
    Scrapers::DistrictDetail.new.call unless District.any?
    Scrapers::LandDetail.new.call
  end
end
