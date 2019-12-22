class AddStreetIdWardIdDistrictIdProvinceIdToLands < ActiveRecord::Migration[6.0]
  def change
    rename_column :lands, :address_id, :street_id
    add_reference :lands, :ward, foreign_key: { to_table: :addresses }
    add_reference :lands, :district, foreign_key: { to_table: :addresses }
    add_reference :lands, :province, foreign_key: { to_table: :addresses }

    Land.find_each do |land|
      land.update(
        province_id: land.province.id,
        district_id: land.district.id,
        ward_id: land.ward.id
      )
    end
  end
end
