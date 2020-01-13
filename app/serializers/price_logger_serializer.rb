class PriceLoggerSerializer < ApplicationSerializer
  attributes :price, :lands_count

  attribute :created_at do |object|
    object.created_at.strftime("%m/%d/%Y")
  end
end
