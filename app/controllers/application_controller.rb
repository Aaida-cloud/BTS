class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    case resource.user_type
    when "admin"
      admin_dashboard_path
    when "manager"
      projects_path
    when "developer"
      developer_dashboard_path
    when "qa"
      qa_dashboard_path
    else
      root_path
    end
  end
end
