class AddIndexToLands < ActiveRecord::Migration[6.0]
  def up
    remove_index :lands, name: :index_lands_on_province_id_with_deleted_at
    add_index :lands, :province_id, where: 'deleted_at is null AND (lands.total_price > 0 AND lands.acreage > 0)', name: :index_lands_on_province_id_with_deleted_at
    add_index :lands, :district_id, where: 'deleted_at is null AND (lands.total_price > 0 AND lands.acreage > 0)', name: :index_lands_on_district_id_with_deleted_at
    add_index :lands, :ward_id, where: 'deleted_at is null AND (lands.total_price > 0 AND lands.acreage > 0)', name: :index_lands_on_ward_id_with_deleted_at
    add_index :lands, :street_id, where: 'deleted_at is null AND (lands.total_price > 0 AND lands.acreage > 0)', name: :index_lands_on_street_id_with_deleted_at
    add_index :lands, :created_at,  where: 'deleted_at is null AND (lands.total_price > 0 AND lands.acreage > 0)', name: :index_lands_on_created_at_with_calculable_columns
  end

  def down
    remove_index :lands, name: :index_lands_on_province_id_with_deleted_at
    remove_index :lands, name: :index_lands_on_district_id_with_deleted_at
    remove_index :lands, name: :index_lands_on_ward_id_with_deleted_at
    remove_index :lands, name: :index_lands_on_street_id_with_deleted_at
    remove_index :lands, name: :index_lands_on_created_at_with_calculable_columns

    add_index :lands, :province_id, where: 'deleted_at is null', name: :index_lands_on_province_id_with_deleted_at
  end
end
