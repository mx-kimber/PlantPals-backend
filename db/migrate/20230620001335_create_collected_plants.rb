class CreateCollectedPlants < ActiveRecord::Migration[7.0]
  def change
    create_table :collected_plants do |t|
      t.integer :user_id
      t.integer :plant_id
      t.string :nickname
      t.text :notes
      t.string :custom_image

      t.timestamps
    end
  end
end
