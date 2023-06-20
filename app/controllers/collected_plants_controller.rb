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

    if @collected_plant.destroy
      render json: { message: "Collected plant destroyed successfully" }
    else
      render json: { message: "Collected Plant not found" }, status: :not_found
    end
  end

  private

  def collected_plant_params
    params.permit(:id, :plant_id, :user_id, :nickname, :custom_image, :notes)
  end
end
