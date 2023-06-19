class PlantsController < ApplicationController

  def index
    @plants = Plant.all
    render :index
  end

  def show
    @plant = Plant.find_by(id: params[:id])
    render :show
  end

  def create
    @plant = Plant.create(plant_params)
    if @plant.save
      render :show
    else
      render json: { errors: @plant.errors.full_messages }, status: :unprocessable_entity
    end
  end
  


  private

  def plant_params
    params.permit(
      :common_name, 
      :latin_name,
      :img,
      :watering,
      :light_ideal,
      :light_tolerated,
      :climate,
      :category 
    )
  end

end
