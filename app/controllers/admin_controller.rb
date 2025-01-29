class AdminController < ApplicationController
  before_action :authorize_admin

  def index
    @users = User.where.not(user_type: :admin)
  end

  def update_user_type
    user = User.find(params[:id])
    if user.update(user_type: params[:user_type])
      flash[:success] = "User role updated!"
    else
      flash[:error] = "Oops! Something went wrong"
    end
    redirect_to admin_dashboard_path
  end

  def toggle_user
    user = User.find(params[:id])
    user.update(enabled: !user.enabled)
    redirect_to admin_dashboard_path, notice: "User access updated!"
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
  end
end

