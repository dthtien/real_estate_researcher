class AddTotalPriceAndSquareMeterPriceToHistoryPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :history_prices, :square_meter_price, :float
    rename_column :history_prices, :price, :total_price
  end
end
