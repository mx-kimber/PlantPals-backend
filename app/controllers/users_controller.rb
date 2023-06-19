class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  before_action :current_user, except: [:create]

  def index
    if current_user
      @users = [current_user]
      render :index
    else
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end
  

  def show
    if current_user
      @user = current_user
      render :show
    else
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if current_user && current_user.id.to_s == params[:id]
      @user = User.find_by(id: params[:id])
      @user.assign_attributes(user_params)

      if @user.save
        render :show
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end

  def destroy
    # if current_user && current_user.id.to_s == params[:id]
      @user = User.find_by(id: params[:id])
      if @user.destroy
        render json: { message: "User has been destroyed successfully" }
      else
        render json: { error: "Unauthorized access" }, status: :unauthorized
      end
    # end
  end
 
  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :profile_img)
  end
end
