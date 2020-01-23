class AddClassificationToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :classification, :integer, default: 8
  end
end
