class CreateLands < ActiveRecord::Migration[5.2]
  def change
    create_table :lands do |t|
      t.float :acreage
      t.float :total_price
      t.float :square_metre_price
      t.text :address_detail
      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
