class LandSerializer < ApplicationSerializer
  attributes :id, :total_price, :square_meter_price, :acreage, :title,
             :description, :post_date, :slug

  attribute :change_times do |object|
    object.history_prices.length
  end

  attribute :classification do |object|
    classififcation = Land.classifications[object.classification]
    Scrapers::LandDetail::LAND_CLASSIFICATION_KEYS[classififcation]
  end
end
