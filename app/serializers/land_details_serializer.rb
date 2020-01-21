class LandDetailsSerializer < ApplicationSerializer
  attributes :id, :total_price, :square_meter_price, :acreage, :title,
             :description, :post_date, :slug, :address, :source_url

  attribute :updated_at do |object|
    object.updated_at.strftime('%H:%M:%S %d-%m-%Y')
  end
end
