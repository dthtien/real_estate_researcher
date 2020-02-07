class AddUserIdToLands < ActiveRecord::Migration[6.0]
  def change
    add_reference :lands, :user, foreign_key: true
  end
end
