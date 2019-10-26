class AddLandsCountToPriceLoggers < ActiveRecord::Migration[6.0]
  def change
    add_column :price_loggers, :lands_count, :integer, default: 0
  end
end
