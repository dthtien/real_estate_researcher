class LandSerializer < ApplicationSerializer
  attributes :id,
    :total_price,
    :square_meter_price,
    :acreage,
    :title,
    :description,
    :post_date,
    :slug
end
