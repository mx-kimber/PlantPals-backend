class ChangeColumnNameInSchedules < ActiveRecord::Migration[7.0]
  def change
    rename_column :schedules, :collection_id, :collected_plants_id
  end
end
