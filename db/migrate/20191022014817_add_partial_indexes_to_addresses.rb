class AddPartialIndexesToAddresses < ActiveRecord::Migration[6.0]
  def change
    add_index :addresses, :type, where: "type = 'District'", name: 'addresses_partial_type_district'
    add_index :addresses, :type, where: "type = 'Province'", name: 'addresses_partial_type_province'
    add_index :addresses, :type, where: "type = 'Ward'", name: 'addresses_partial_type_ward'
    add_index :addresses, :type, where: "type = 'Street'", name: 'addresses_partial_type_street'
    add_index :addresses, :type, where: "type = 'Address'", name: 'addresses_partial_type_address'
  end
end
