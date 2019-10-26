class PriceLogger < ApplicationRecord
  belongs_to :loggable, polymorphic: true

  scope :newest, -> { order(logged_date: :desc) }
end
