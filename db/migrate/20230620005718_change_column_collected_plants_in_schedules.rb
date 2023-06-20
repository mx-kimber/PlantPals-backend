class ChangeColumnCollectedPlantsInSchedules < ActiveRecord::Migration[7.0]
  def change
    rename_column :schedules, :collected_plants_id, :collected_plant_id
  end
end
