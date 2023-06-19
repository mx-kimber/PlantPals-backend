class PlantsController < ApplicationController

  def index
    @plants = Plant.all
    render :index
  end
end
