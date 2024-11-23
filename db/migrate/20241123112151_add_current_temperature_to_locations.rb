class AddCurrentTemperatureToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :current_temperature, :decimal
  end
end
