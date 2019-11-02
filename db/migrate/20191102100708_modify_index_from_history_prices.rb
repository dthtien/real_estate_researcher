class ModifyIndexFromHistoryPrices < ActiveRecord::Migration[6.0]
  def change
    remove_index :history_prices, %i[total_price acreage land_id]
    add_index(
      :history_prices, %i[total_price acreage land_id posted_date],
      unique: true,
      name: :history_prices_unique_information
    )
  end
end
