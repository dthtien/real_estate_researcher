class AddDeletedAtToHistoryPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :history_prices, :deleted_at, :datetime
    add_index :history_prices, :deleted_at
  end
end
