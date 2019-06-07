namespace :scrapping do
  desc 'start scrappings'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task start: :environment do
    Scrapers::RealEstate.new.call
  end
end