class Address < ApplicationRecord
  extend FriendlyId

  friendly_id :alias_name, use: :slugged
  has_many :price_loggers, -> { newest }, as: :loggable

  scope :avg_square_meter_prices, (lambda do
    joins(:lands)
      .select('
        addresses.id,
        addresses.name,
        addresses.slug,
        (AVG(lands.total_price)::decimal / NULLIF(AVG(lands.acreage),0))
          as avg_square_meter_price')
      .where('lands.total_price > 0 AND lands.acreage > 0')
      .group('addresses.name, addresses.id, addresses.slug')
  end)

  scope :search_by_name, (lambda do |name|
    where('alias_name iLIKE ? OR name iLIKE ?', "%#{name}%", "%#{name}%")
  end)

  scope :calculatable, (lambda do
    joins(:lands).having('count(lands.id) > 0').group(:id)
  end)

  def latest_log
    price_loggers.first
  end

  def second_latest_log
    price_loggers.second
  end

  def lands_count
    lands.count
  end

  def average_price
    price = lands.select(
      '(AVG(lands.total_price)::decimal /  NULLIF(AVG(lands.acreage),0))
        as average_price'
    ).calculatable[0]

    price&.average_price || 0.0
  end

  delegate :price, :logged_date, :lands_count_ratio, :price_ratio,
           to: :latest_log, allow_nil: true

  def show_name
    self.class == Ward ? "#{name}, #{district.name}" : name
  end
end
