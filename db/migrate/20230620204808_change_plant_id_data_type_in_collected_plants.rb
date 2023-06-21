class ChangePlantIdDataTypeInCollectedPlants < ActiveRecord::Migration[7.0]
  def change
    change_column :collected_plants, :plant_id, :string
  end
end

