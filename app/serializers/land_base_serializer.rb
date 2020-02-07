class LandBaseSerializer < ApplicationSerializer
  attributes :id, :total_price, :square_meter_price, :acreage, :title,
             :description, :post_date, :slug, :front_length

  attribute :classification do |object|
    classififcation = Land.classifications[object.classification]
    Scrapers::LandDetail::LAND_CLASSIFICATION_KEYS[classififcation]
  end

  attribute :updated_at do |object|
    object.updated_at.strftime('%H:%M:%S %d-%m-%Y')
  end

  attribute :change_times do |object|
    object.history_prices.length
  end
end
