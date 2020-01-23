class AddFrontLengthToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :front_length, :float
  end
end
