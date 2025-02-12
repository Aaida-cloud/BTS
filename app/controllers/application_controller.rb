class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.manager?
      projects_path
    elsif resource.developer?
      developer_projects_path
    elsif resource.qa?
      qa_projects_path
    else
      root_path
    end
  end
end
