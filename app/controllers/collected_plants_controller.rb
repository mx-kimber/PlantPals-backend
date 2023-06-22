require 'http'
class CollectedPlantsController < ApplicationController
  before_action :authenticate_user


  def index 
    @collected_plants = current_user.collected_plants.order(created_at: :desc)
    render :index
  end

  def show
    @collected_plant = CollectedPlant.find(params[:id])

    response = api_get_request("https://house-plants2.p.rapidapi.com/id/#{@collected_plant[:plant_id]}")

    if response.code == 200
      plant_data = JSON.parse(response.body)
      @plant_data = {
        'id' => plant_data['id'],
        'common_name' => plant_data['Common name (fr.)'] || 'Unknown',
        'latin_name' => plant_data['Latin name'] || 'Unknown',
        'img' => plant_data['Img'] || 'Unknown',
        'watering' => plant_data['Watering'] || 'Unknown',
        'light_ideal' => plant_data['Light ideal'] || 'Unknown',
        'light_tolerated' => plant_data['Light tolered'] || 'Unknown',
        'climate' => plant_data['Climat'] || 'Unknown',
        'category' => plant_data['Categories'] || 'Unknown',
        'url' => plant_data['Url'] || 'Resource not found'
      }

      render json: { collected_plant: @collected_plant, plant_data: @plant_data }
    else
      render json: { error: "Failed to retrieve plant data. Error code: #{response.code}" }, status: :unprocessable_entity
    end
  end

  def create
    plant_id = params[:plant_id]
    user_id = current_user.id
    @plant_data = retrieve_plant_data(plant_id)

    @collected_plant = CollectedPlant.new(
      plant_id: plant_id,
      user_id: user_id,
      nickname: params[:nickname],
      notes: params[:notes]
    )

    if @collected_plant.save
      redirect_to @collected_plant, notice: "Plant saved to collection successfully."
    else
      flash[:error] = @collected_plant.errors.full_messages.join(", ")
      redirect_to plant_path(plant_id)
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

    if @collected_plant.destroy
      render json: { message: "Collected plant destroyed successfully" }
    else
      render json: { message: "Collected Plant not found" }, status: :not_found
    end
  end

  private

  def collected_plant_params
    params.permit(:plant_id, :user_id, :nickname, :custom_image, :notes)
  end
  
  def retrieve_plant_data(plant_id)
    url = "https://house-plants2.p.rapidapi.com/id/#{plant_id}"
    response = api_get_request(url)
    JSON.parse(response.body)
  end
end
