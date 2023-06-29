class AddPlantAttributesToCollectedPlants < ActiveRecord::Migration[7.0]
  def change
    add_column :collected_plants, :common_name, :string
    add_column :collected_plants, :latin_name, :string
    add_column :collected_plants, :img, :string
    add_column :collected_plants, :watering, :string
    add_column :collected_plants, :light_ideal, :string
    add_column :collected_plants, :light_tolerated, :string
    add_column :collected_plants, :climate, :string
    add_column :collected_plants, :category, :string
    add_column :collected_plants, :url, :string
  end
end
