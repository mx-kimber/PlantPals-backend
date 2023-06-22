json.extract! collected_plant, :id, :user_id, :plant_id, :nickname, :notes, :custom_image, :created_at

if @plant_data.present?
  json.plant_data do
    json.extract! @plant_data, 'id', 'common_name', 'latin_name', 'img', 'watering', 'light_ideal', 'light_tolerated', 'climate', 'category', 'url'
  end
else
  json.plant_data 'Plant data not available'
end

if collected_plant.schedule
  json.schedule do
    json.extract! collected_plant.schedule, :id, :user_id, :collected_plant_id, :watering_start_date, :days_to_water
  end
else
  json.schedule "No schedule available"
end
