class SchedulesController < ApplicationController
  before_action :authenticate_user

  def index
    @schedules = current_user.schedules.includes(:collected_plant)
    render json: @schedules, include: [:collected_plant]
  end

  def show
    @schedule = Schedule.find(params[:id])
    render json: @schedule, include: [:collected_plant]
  end

  def create
    @collected_plant = current_user.collected_plants.find(params[:collected_plant_id])
    @schedule = @collected_plant.schedule || @collected_plant.build_schedule

    if @schedule.update(schedule_params)
      render json: @schedule, include: [:collected_plant], status: :created
    else
      render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule
      if @schedule.update(schedule_params)
        render json: @schedule, include: [:collected_plant]
      else
        render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Schedule not found'] }, status: :not_found
    end
  end

  def destroy
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule
      if @schedule.destroy
        render json: { message: 'Schedule destroyed successfully' }
      else
        render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Schedule not found'] }, status: :not_found
    end
  end

  private

  def schedule_params
    params.permit(:user_id, :collected_plant_id, :watering_start_date, :days_to_water)
  end
end