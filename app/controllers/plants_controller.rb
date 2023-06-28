require 'http'

class PlantsController < ApplicationController
  before_action :authenticate_user
  
  def index
    response = api_get_request('https://house-plants2.p.rapidapi.com/all')
  
    if response.code == 200
      plant_data = JSON.parse(response.body)
  
      @plants = plant_data.first(20).map do |plant_data|
        {
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
      end
  
      render json: @plants
    else
      render json: { error: "Failed to retrieve plant data. Error code: #{response.code}" }, status: :unprocessable_entity
    end
  end
  

  def show
    @plant = Plant.find_by(id: params[:id])
    response = api_get_request("https://house-plants2.p.rapidapi.com/id/#{params[:id]}")
  
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
  
      render json: @plant_data

    else
      flash[:error] = "Failed to retrieve plant data. Error code: #{response.code}"
      
    end
  end

    
  private

  def plant_params
  params.require(:plant).permit(:common_name, :latin_name, :img, :watering, :light_ideal, :light_tolerated, :climate, :category, :url)
  end
end