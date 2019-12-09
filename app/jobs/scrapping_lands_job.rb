class ScrappingLandsJob < ApplicationJob
  queue_as :critical
  CRITICAL_QUEUE = 'critical'.freeze

  def perform(district_ids = [2])
    return if running?(district_ids)

    District.where(id: district_ids).each do |district|
      Scrapers::LandDetail.new.call_with_district(district)
    end
  end

  private

  def running?(district_ids)
    workers = Sidekiq::Workers.new

    crawling_ids = workers.map do |_process_id, _thread_id, work|
      if work['queue'] == CRITICAL_QUEUE
        work['payload']['args'][0]['arguments'][0]
      end
    end

    crawling_ids.include?(district_ids)
  end
end
