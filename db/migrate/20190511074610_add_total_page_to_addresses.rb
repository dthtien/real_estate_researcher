class AddTotalPageToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :total_page, :integer
  end
end
