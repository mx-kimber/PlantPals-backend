class SchedulesController < ApplicationController
  before_action :authenticate_user

  def index
    @schedules = current_user.schedules
    render json: @schedules
  end

  def show
    @schedule = Schedule.find(params[:id])
    render json: @schedule
  end

  def create
    @collected_plant = current_user.collected_plants.find(params[:collected_plant_id])
    @schedule = @collected_plant.schedule
  
    if @schedule
      if @schedule.update(schedule_params)
        render json: @schedule
      else
        render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
      end
    else
      @schedule = @collected_plant.build_schedule(schedule_params)
  
      if @schedule.save
        render json: @schedule, status: :created
      else
        render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  

  def update
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule
      if @schedule.update(schedule_params)
        render json: @schedule
      else
        render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Schedule not found'] }, status: :not_found
    end
  end

  def destroy
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule.destroy
      render json: { message: "Schedule destroyed successfully" }
    else
      render json: { message: "Deletion canceled" }
    end
  end

  private

  def schedule_params
    params.permit(:user_id, :collected_plant_id, :watering_start_date, :days_to_water)
  end
end