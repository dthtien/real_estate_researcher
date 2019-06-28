class ChangeScrapingLinkToNomalColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :scrapping_link, :string
  end
end
