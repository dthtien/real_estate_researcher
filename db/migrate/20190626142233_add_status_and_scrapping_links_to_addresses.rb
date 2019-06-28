class AddStatusAndScrappingLinksToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :status, :boolean
    add_column :addresses, :scrapping_links, :text, array: true, default: []
  end
end
