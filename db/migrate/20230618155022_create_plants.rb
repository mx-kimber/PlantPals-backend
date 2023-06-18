class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :common_name
      t.string :latin_name
      t.string :img
      t.string :watering
      t.string :light_ideal
      t.string :light_tolerated
      t.string :climate
      t.string :category

      t.timestamps
    end
  end
end
