class District < Address
  belongs_to :province, foreign_key: :parent_id
  has_many :wards, foreign_key: :parent_id
  has_many :streets, through: :wards

  def lands
    Land.joins(<<-SQL.strip_heredoc
        INNER JOIN "addresses" ON "lands"."address_id" = "addresses"."id"
        INNER JOIN "addresses" "wards_lands"
          ON "addresses"."parent_id" = "wards_lands"."id"
          WHERE "wards_lands"."type" IN ('Ward')
          AND "wards_lands"."parent_id" = #{id}
        SQL
      )
  end
end
