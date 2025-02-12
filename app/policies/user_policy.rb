class UserPolicy < ApplicationPolicy
  def enable_disable?
    user.admin?
  end

  def update_role?
    user.admin?
  end
end
