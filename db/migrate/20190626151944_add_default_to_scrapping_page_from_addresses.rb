class AddDefaultToScrappingPageFromAddresses < ActiveRecord::Migration[5.2]
  def up
    change_column :addresses, :scrapping_page, :integer, default: 0
  end

  def down
    change_column :addresses, :scrapping_page, :integer
  end
end
