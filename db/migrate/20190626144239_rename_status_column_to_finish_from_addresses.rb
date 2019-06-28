class RenameStatusColumnToFinishFromAddresses < ActiveRecord::Migration[5.2]
  def change
    rename_column :addresses, :status, :finish
  end
end
