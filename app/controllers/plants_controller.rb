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

      render :index
    else
      flash[:error] = "Failed to retrieve plant data. Error code: #{response.code}"
      redirect_to root_path
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
      # redirect_to root_path
    end
  end
   

  private

  def api_get_request(url)
    headers = {
      'X-RapidAPI-Key' => '',
      'X-RapidAPI-Host' => 'house-plants2.p.rapidapi.com'
    }

    HTTP.headers(headers).get(url)
  end
end


