class AddUniquenessPriceIndexToHistoryPrices < ActiveRecord::Migration[6.0]
  def change
    add_index :history_prices, %i[total_price acreage land_id], unique: true
  end
end
