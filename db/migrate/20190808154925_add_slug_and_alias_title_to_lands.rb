class AddSlugAndAliasTitleToLands < ActiveRecord::Migration[5.2]
  def up
    add_column :lands, :slug, :string
    add_index :lands, :slug, unique: true
    add_column :lands, :alias_title, :string

    Land.with_deleted.each do |land|
      land.alias_title = VietnameseSanitizer.execute!(land.title)
      land.save
    end

  end

  def down
    remove_column :lands, :slug
    remove_index :lands, :slug
    remove_column :lands, :alias_title
  end
end
