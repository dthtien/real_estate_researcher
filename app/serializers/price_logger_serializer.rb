class PriceLoggerSerializer < ApplicationSerializer
  attributes :price, :lands_count

  attribute :created_at do |object|
    object.created_at.strftime("%d/%m/%Y")
  end
end
