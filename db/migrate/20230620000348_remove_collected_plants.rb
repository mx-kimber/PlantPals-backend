class RemoveCollectedPlants < ActiveRecord::Migration[7.0]
  def change
    drop_table :collected_plants
  end
end
