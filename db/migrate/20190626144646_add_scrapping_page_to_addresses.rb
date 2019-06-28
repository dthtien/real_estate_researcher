class AddScrappingPageToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :scrapping_page, :integer
  end
end
