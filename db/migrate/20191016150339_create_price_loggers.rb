class CreatePriceLoggers < ActiveRecord::Migration[6.0]
  def change
    create_table :price_loggers do |t|
      t.float :price
      t.integer :loggable_id
      t.string :loggable_type
      t.date :logged_date
      t.index %i[loggable_id loggable_type]
      t.index %i[loggable_id loggable_type logged_date], unique: true, name: :logged_date_unique_index

      t.timestamps
    end
  end
end
