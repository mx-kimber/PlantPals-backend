class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :collected_plant
  
  validates :user_id, presence: true
  validates :collected_plant_id, presence: true
  validates :watering_start_date, presence: true
  validates :days_to_water, presence: true
  
end
