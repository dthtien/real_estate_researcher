class ChangeAddressIdToWardIdFromLands < ActiveRecord::Migration[5.2]
  def change
    rename_column :lands, :address_id, :ward_id
  end
end
