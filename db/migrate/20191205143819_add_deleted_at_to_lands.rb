class AddDeletedAtToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :deleted_at, :datetime
    add_index :lands, :deleted_at
  end
end
