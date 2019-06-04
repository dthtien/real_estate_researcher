class RenameSquareMetrePriceToSquareMeterPrices < ActiveRecord::Migration[5.2]
  def change
    rename_column :lands, :square_metre_price, :square_meter_price
  end
end
