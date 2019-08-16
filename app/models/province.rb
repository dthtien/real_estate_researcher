class Province < Address
  has_many :districts, foreign_key: :parent_id
  has_many :wards, through: :districts
  has_many :streets, through: :wards
  has_many :lands, through: :streets

  def lands
    Land.select('lands.*, COUNT(history_prices.id) history_prices_count')
      .joins(<<-SQL.strip_heredoc
        LEFT OUTER JOIN "history_prices" ON "history_prices"."land_id" = "lands"."id"
        INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
        INNER JOIN "addresses" "districts_lands"
          ON "wards_lands"."parent_id" = "districts_lands"."id"
          WHERE "districts_lands"."type" IN ('District')
          AND "districts_lands"."parent_id" = #{id}
        SQL
      ).group(:id)
      .order("history_prices_count desc")
  end
end
