class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :ward
      t.string :district

      t.timestamps
    end
  end
end
