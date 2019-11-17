class Land < ApplicationRecord
  extend FriendlyId
  friendly_id :alias_title, use: :slugged

  belongs_to :street, foreign_key: :address_id
  has_many :history_prices
  has_one :ward, through: :street
  has_one :district, through: :ward

  scope :with_history_prices, (lambda do
    select('lands.*, COUNT(history_prices.id) history_prices_count')
      .left_outer_joins(:history_prices)
      .group(:id, 'addresses.name')
  end)

  scope :district_relation, (lambda do |district_id|
    joins(
      <<-SQL.strip_heredoc
        INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
          AND "wards_lands"."type" IN ('Ward')
          AND "wards_lands"."parent_id" = #{district_id}
      SQL
    )
  end)

  scope :province_relation, (lambda do |province_id|
    joins(
      <<-SQL.strip_heredoc
      INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
        INNER JOIN "addresses" "districts_lands"
          ON "wards_lands"."parent_id" = "districts_lands"."id"
          AND "districts_lands"."type" IN ('District')
          AND "districts_lands"."parent_id" = #{province_id}
      SQL
    )
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

  scope :ordering, (lambda do |params|
    if params['history_price']
      order = params['history_price'] == 'desc' ? 'desc' : 'asc'
      calculatable.order("history_prices_count #{order}")
    else
      calculatable.order(params)
    end
  end)

  scope :average_price_calculate, (lambda do
    select(
      '(AVG(lands.total_price)::decimal /  NULLIF(AVG(lands.acreage),0))
        as average_price'
    )
  end)
end
