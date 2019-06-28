class RenameColumnScrappingLinksToScrappingLinkFromAddresses < ActiveRecord::Migration[5.2]
  def change
    rename_column :addresses, :scrapping_links, :scrapping_link
  end
end
