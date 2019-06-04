class AddProvinceToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :province, :string
  end
end
