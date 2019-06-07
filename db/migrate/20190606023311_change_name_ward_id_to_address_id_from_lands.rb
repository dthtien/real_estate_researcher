class ChangeNameWardIdToAddressIdFromLands < ActiveRecord::Migration[5.2]
  def change
    rename_column :lands, :ward_id, :address_id
  end
end
