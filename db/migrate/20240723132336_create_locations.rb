class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :country
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
