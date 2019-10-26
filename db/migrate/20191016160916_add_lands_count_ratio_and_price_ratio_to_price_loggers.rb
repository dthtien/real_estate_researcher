class AddLandsCountRatioAndPriceRatioToPriceLoggers < ActiveRecord::Migration[6.0]
  def change
    add_column :price_loggers, :lands_count_ratio, :integer
    add_column :price_loggers, :price_ratio, :integer
  end
end
