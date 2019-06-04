class AddPostedDateToHistoryPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :history_prices, :posted_date, :date
  end
end
