class DistributeJob < ApplicationJob
  def perform(offset = 1)
    District.all.each_slice(offset) do |districts|
      ScrappingLandsJob.perform_later(districts.pluck(:id))
    end
  end
end
