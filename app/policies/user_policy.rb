class UserPolicy < ApplicationPolicy
  def toggle_user?
    user.admin?
  end

  def update_user_type?
    user.admin?
  end
end
