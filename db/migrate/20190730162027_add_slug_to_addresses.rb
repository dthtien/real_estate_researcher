class AddSlugToAddresses < ActiveRecord::Migration[5.2]
  def up
    add_column :addresses, :slug, :string
    add_index :addresses, :slug, unique: true
    Address.find_each(&:save)
  end

  def down
    remove_index :addresses, :slug
    remove_column :addresses, :slug
  end
end
