class AddUrlToPlants < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :url, :string
  end
end
