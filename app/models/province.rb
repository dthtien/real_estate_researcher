class Province < Address
  has_many :districts, foreign_key: :parent_id
  has_many :wards, through: :districts
  has_many :streets, through: :wards
  has_many :lands, through: :streets

  def lands
    Land.joins(<<-SQL.strip_heredoc
        INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
        INNER JOIN "addresses" "districts_lands"
          ON "wards_lands"."parent_id" = "districts_lands"."id"
          WHERE "districts_lands"."type" IN ('District')
          AND "districts_lands"."parent_id" = #{id}
        SQL
      )
  end
end
