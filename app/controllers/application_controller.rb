class ApplicationController < ActionController::Base
<<<<<<< Updated upstream
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
=======
  before_action :authenticate_user!  # Ensure users are logged in

  def after_sign_in_path_for(resource)
    case resource.user_type
    when "admin"
      admin_dashboard_path
    when "manager"
      manager_dashboard_path
    when "developer"
      developer_dashboard_path
    when "qa"
      qa_dashboard_path
    else
      root_path  # Default
    end
  end
>>>>>>> Stashed changes
end
