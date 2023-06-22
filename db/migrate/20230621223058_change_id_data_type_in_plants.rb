class ChangeIdDataTypeInPlants < ActiveRecord::Migration[7.0]
  def change
    change_column :plants, :id, :string
  end
end
