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
      .group(:id)
      .order('history_prices_count desc')
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
  scope :new_lands_custom, (lambda do
    where('"lands"."post_date" BETWEEN ? AND ?',
        Time.current.beginning_of_day, Time.current.end_of_day)
  end)
end
