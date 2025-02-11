class Api::V1::AdminController < ApplicationController
  before_action :authorize_admin

  def index
    users = User.where.not(user_type: :admin)
    render json: { users: users }, status: :ok
  end

  def update_user_type
    user = User.find_by(id: params[:id])

    if user.nil?
      return render json: { error: "User not found" }, status: :not_found
    end

    if user.update(user_type: params[:user_type])
      render json: { message: "User role updated successfully", user: user }, status: :ok
    else
      render json: { error: "Failed to update user role", details: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def toggle_user
    user = User.find_by(id: params[:id])

    if user.nil?
      return render json: { error: "User not found" }, status: :not_found
    end

    user.update(enabled: !user.enabled)
    render json: { message: "User access updated", user: user }, status: :ok
  end

  private

  def authorize_admin
    unless current_user.admin?
      render json: { error: "Access Denied!" }, status: :forbidden
    end
  end
end
