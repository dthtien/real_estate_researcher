class AddHistoryPriceUniqueIndexToHistoryPrices < ActiveRecord::Migration[6.0]
  def change
    add_index :history_prices, %i[total_price acreage land_id posted_date deleted_at], unique: true, name: :history_price_unique_index
  end
end
