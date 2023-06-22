require 'http'
class CollectedPlantsController < ApplicationController
  before_action :authenticate_user

  def index
    @collected_plants = current_user.collected_plants.order(created_at: :desc)
    collected_plants_data = []

    @collected_plants.each do |collected_plant|
      plant_data = retrieve_plant_data(collected_plant[:plant_id])
      next unless plant_data

      schedule_data = collected_plant.schedule ? schedule_data(collected_plant.schedule) : 'No schedule available'

      collected_plant_data = {
        'collected_plant' => collected_plant,
        'plant_data' => plant_data,
        'schedule' => schedule_data
      }

      collected_plants_data << collected_plant_data
    end

    render json: collected_plants_data
  end

  def show
    @collected_plant = CollectedPlant.find(params[:id])
    plant_data = retrieve_plant_data(@collected_plant[:plant_id])
    schedule_data = @collected_plant.schedule ? schedule_data(@collected_plant.schedule) : 'No schedule available'

    if plant_data
      render json: {
        collected_plant: @collected_plant,
        plant_data: plant_data,
        schedule: schedule_data
      }
    else
      render json: { error: "Failed to retrieve plant data." }, status: :unprocessable_entity
    end
  end

  def create
    plant_id = params[:plant_id]
    @user_id = current_user.id
    @plant_data = retrieve_plant_data(plant_id)

    @collected_plant = CollectedPlant.new(collected_plant_params)

    if @collected_plant.save
      redirect_to @collected_plant, notice: "Plant saved to collection successfully."
    else
      flash[:error] = @collected_plant.errors.full_messages.join(", ")
      redirect_to plant_path(plant_id)
    end
  end

  def update
    @collected_plant = CollectedPlant.find_by(id: params[:collected_plant_id])
  
    if @collected_plant
      if @collected_plant.update(collected_plant_params)
        render :show
      else
        render json: { errors: @collected_plant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Collected Plant not found'] }, status: :not_found
    end
  end
  
  def destroy
    @collected_plant = CollectedPlant.find_by(id: params[:id])

    if @collected_plant
      if @collected_plant.destroy
        render json: { message: "Collected plant destroyed successfully" }
      else
        render json: { errors: @collected_plant.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Collected Plant not found'] }, status: :not_found
    end
  end

  private

  def collected_plant_params
    params.permit(:plant_id, :user_id, :nickname, :custom_image, :notes)
  end
  
  def retrieve_plant_data(plant_id)
    url = "https://house-plants2.p.rapidapi.com/id/#{plant_id}"
    response = api_get_request(url)
    response.code == 200 ? JSON.parse(response.body) : nil
  end

  def schedule_data(schedule)
    {
      'id' => schedule.id,
      'collected_plant_id' => schedule.collected_plant_id,
      'watering_start_date' => schedule.watering_start_date,
      'days_to_water' => schedule.days_to_water
    }
  end
end
