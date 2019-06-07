class RemoveUselessColumnsFromAddress < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :street
    remove_column :addresses, :ward
    remove_column :addresses, :district
    remove_column :addresses, :province
  end
end
