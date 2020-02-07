class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone_number
      t.string :name
      t.integer :selling_times, default: 0
      t.boolean :agency, default: false

      t.timestamps
    end
  end
end
