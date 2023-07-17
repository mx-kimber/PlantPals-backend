require 'http'

class CollectedPlantsController < ApplicationController
  before_action :authenticate_user
  
  def index
    @collected_plants = current_user.collected_plants.order(created_at: :desc)
    render :index
  end

  def show
    @collected_plant = CollectedPlant.find(params[:id])
    render :show
  end

  def create
    @collected_plant = current_user.collected_plants.build(collected_plant_params)
    plant_data = Plant.find_or_create_by(id: @collected_plant.plant_id)
    plant_data = retrieve_plant_data(@collected_plant.plant_id)

    if plant_data.nil?
      render json: { error: 'Failed to retrieve plant data from the API' }, status: :unprocessable_entity
      return
    end

   
    @collected_plant.assign_attributes(
      common_name: plant_data['Common name (fr.)'] || 'Unknown',
      latin_name: plant_data['Latin name'] || 'Unknown',
      img: plant_data['Img'] || 'Unknown',
      watering: plant_data['Watering'] || 'Unknown',
      light_ideal: plant_data['Light ideal'] || 'Unknown',
      light_tolerated: plant_data['Light tolered'] || 'Unknown',
      climate: plant_data['Climat'] || 'Unknown',
      category: plant_data['Categories'] || 'Unknown',
      url: plant_data['Url'] || 'Resource not found'
    )

    if @collected_plant.save
      render :show
    else
      render json: { errors: @collected_plant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @collected_plant = CollectedPlant.find_by(id: params[:id])
  
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
      if confirm_destroy?
        @collected_plant.destroy
        render json: { message: "Collected plant destroyed successfully" }
      else
        render json: { message: "Deletion canceled" }
      end
    else
      render json: { errors: ['Collected Plant not found'] }, status: :not_found
    end
  end

  private

  def collected_plant_params
    params.permit(:plant_id,:nickname, :custom_image, :notes)
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
