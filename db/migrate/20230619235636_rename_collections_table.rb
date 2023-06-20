class RenameCollectionsTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :collections, :collected_plants
  end
end
