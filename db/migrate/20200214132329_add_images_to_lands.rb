class AddImagesToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :images, :jsonb, array: true, default: []
  end
end
