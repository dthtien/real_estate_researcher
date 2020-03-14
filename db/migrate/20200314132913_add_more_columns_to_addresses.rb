class AddMoreColumnsToAddresses < ActiveRecord::Migration[6.0]
  def up
    add_column :addresses, :land_only_price, :float
    add_column :addresses, :apartment_price, :float
    add_column :addresses, :house_price, :float
    add_column :addresses, :farm_price, :float
    add_column :addresses, :lands_count, :integer

    Addresses::PriceLogger.new.call
  end

  def down
    remove_column :addresses, :land_only_price
    remove_column :addresses, :apartment_price
    remove_column :addresses, :house_price
    remove_column :addresses, :farm_price
    remove_column :addresses, :lands_count
  end
end
