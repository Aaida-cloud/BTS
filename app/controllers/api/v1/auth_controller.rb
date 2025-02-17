class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :authenticate_user!, only: [:destroy]
  protect_from_forgery with: :null_session, only: [:destroy]

  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = user.generate_jwt
      render json: { message: 'Logged in successfully.', user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end


  def destroy
    if current_user

      current_user.update(jti: SecureRandom.uuid)

      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: 'No active session.' }, status: :unauthorized
    end
  end
end

