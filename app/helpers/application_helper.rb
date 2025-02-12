module ApplicationHelper
  def users_not_admin_or_manager
    User.where.not(user_type: ['manager', 'admin'])
  end
end
