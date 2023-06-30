class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  # before_action :current_user
 

  def current_user
    auth_headers = request.headers["Authorization"]
    if auth_headers.present? && auth_headers[/(?<=\A(Bearer ))\S+\z/]
      token = auth_headers[/(?<=\A(Bearer ))\S+\z/]
      begin
        decoded_token = JWT.decode(
          token,
          Rails.application.credentials.fetch(:secret_key_base),
          true,
          { algorithm: "HS256" }
        )
        User.find_by(id: decoded_token[0]["user_id"])
      rescue JWT::ExpiredSignature
        nil
      end
    end
  end

  def authenticate_user
    unless current_user
      render json: { error: "Please log in or sign up" }, status: :unauthorized
    end
  end

  def api_get_request(url)
    headers = {
      'X-RapidAPI-Key' => Rails.application.credentials.rapidapi[:api_key],
      'X-RapidAPI-Host' => 'house-plants2.p.rapidapi.com'
    }
  
    HTTP.headers(headers).get(url)
  end
  

  def retrieve_plant_data(plant_id)
    url = "https://house-plants2.p.rapidapi.com/id/#{plant_id}"
    response = api_get_request(url)
    response.code == 200 ? JSON.parse(response.body) : nil
  end 
end