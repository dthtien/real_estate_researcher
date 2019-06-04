class AddPostDateToLands < ActiveRecord::Migration[5.2]
  def change
    add_column :lands, :post_date, :date
  end
end
