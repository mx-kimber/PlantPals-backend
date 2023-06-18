class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.integer :collection_id
      t.integer :days_to_water
      t.datetime :watering_start_date

      t.timestamps
    end
  end
end
