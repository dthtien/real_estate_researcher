class AddGinIndexingForLandsAddAddresses < ActiveRecord::Migration[6.0]
  def up
    enable_extension 'pg_trgm'
    enable_extension 'btree_gin'
    add_index :lands, :address_detail, using: :gin
    add_index :lands, :title, using: :gin
    add_index :lands, :alias_title, using: :gin
    add_index :addresses, :name, using: :gin
    add_index :addresses, :alias_name, using: :gin
  end

  def down
    disable_extension 'pg_trgm'
    disable_extension 'btree_gin'
    remove_index :lands, :address_detail if index_exists?(:lands, :address_detail)
    remove_index :lands, :title if index_exists?(:lands, :address_title)
    remove_index :lands, :alias_title if index_exists?(:lands, :alias_title)
    remove_index :addresses, :name if index_exists?(:addresses, :name)
    remove_index :addresses, :alias_name if index_exists?(:addresses, :alias_name)
  end
end
