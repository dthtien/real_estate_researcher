class AddDefaultToStatusFromAddress < ActiveRecord::Migration[5.2]
  def up
    change_column :addresses, :status, :boolean, default: false
  end

  def down
    change_column :addresses, :status, :boolean
  end
end
