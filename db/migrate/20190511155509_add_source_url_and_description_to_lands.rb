class AddSourceUrlAndDescriptionToLands < ActiveRecord::Migration[5.2]
  def change
    add_column :lands, :source_url, :string
    add_column :lands, :description, :text
  end
end
