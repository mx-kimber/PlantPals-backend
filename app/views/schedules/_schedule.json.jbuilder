json.array! @schedules do |schedule|
  json.id schedule.id
  json.user_id schedule.user.id
  json.collected_plant_id schedule.collected_plant_id
  json.nickname schedule.collected_plant.nickname
  json.watering_start_date schedule.watering_start_date
  json.days_to_water schedule.days_to_water

  json.collected_plant do
    json.extract! schedule.collected_plant, :id, :user_id, :plant_id, :nickname, :notes, :custom_image, :created_at
  end
end


