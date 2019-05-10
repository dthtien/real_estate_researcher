class CreateHistoryPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :history_prices do |t|
      t.float :price
      t.float :acreage
      t.references :land

      t.timestamps
    end
  end
end
