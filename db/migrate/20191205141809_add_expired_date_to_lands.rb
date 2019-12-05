class AddExpiredDateToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :expired_date, :date
  end
end
