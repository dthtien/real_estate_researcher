class Land < ApplicationRecord
  extend FriendlyId
  acts_as_paranoid
  friendly_id :alias_title, use: :slugged

  has_many :history_prices, dependent: :destroy
  belongs_to :street
  has_one :ward, through: :street
  has_one :district, through: :ward
  has_one :province, through: :district

  scope :with_history_prices, (lambda do
    select('lands.*, COUNT(history_prices.id) history_prices_count')
      .left_outer_joins(:history_prices)
      .group(:id)
  end)

  scope :top_fluctuate, -> { with_history_prices.limit(10) }

  scope :new_lands_count, -> { new_lands.size }

  scope :new_lands, (lambda do
    where(post_date: [Time.current.beginning_of_day..Time.current.end_of_day])
  end)

  scope :calculatable, (lambda do
    where('lands.total_price > 0 AND lands.acreage > 0')
  end)

  scope :with_street_name, (lambda do
    select('lands.*, addresses.name address')
      .joins(:street)
      .group(:id, 'addresses.name')
  end)

  scope :rendering, (lambda do |params|
    calculatable.order(params)
  end)

  scope :average_price_calculate, (lambda do
    calculatable.present? ? calculatable.average(:square_meter_price) : 0
  end)
end
