class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards

  def lands
    Land.select('lands.*, COUNT(history_prices.id) history_prices_count')
      .joins(<<-SQL.strip_heredoc
        LEFT OUTER JOIN "history_prices" ON "history_prices"."land_id" = "lands"."id"
        INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
          WHERE "wards_lands"."type" IN ('Ward')
          AND "wards_lands"."parent_id" = #{id}
        SQL
      ).group(:id)
      .order("history_prices_count desc")
  end
end
