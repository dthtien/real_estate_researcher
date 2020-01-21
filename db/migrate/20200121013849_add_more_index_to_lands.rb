class AddMoreIndexToLands < ActiveRecord::Migration[6.0]
  def change
    add_index :lands, :post_date, where: 'deleted_at is null'
    add_index :lands, :province_id, where: 'deleted_at is null', name: 'index_lands_on_province_id_with_deleted_at'
  end
end
