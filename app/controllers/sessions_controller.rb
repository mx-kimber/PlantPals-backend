class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      jwt = JWT.encode(
        {
          user_id: user.id, 
          exp: 24.hours.from_now.to_i 
        },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256"
      )
      render json: { jwt: jwt, email: user.email, user_id: user.id }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end