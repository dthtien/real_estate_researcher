class AddNameAliasNameParentIdTypeToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :name, :string
    add_column :addresses, :alias_name, :string
    add_column :addresses, :type, :string
    add_column :addresses, :parent_id, :integer
    add_index :addresses, :parent_id
  end
end
