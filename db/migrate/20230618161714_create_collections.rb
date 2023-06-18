class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.integer :user_id
      t.integer :plant_id
      t.string :nickname
      t.string :custom_img
      t.text :notes

      t.timestamps
    end
  end
end
