class ProjectPolicy < ApplicationPolicy

  def index?
    user.manager? || user.qa? || user.developer?
  end

  def show?
    user.manager? || user.qa? || (user.developer? && record.users.include?(user))
  end

  def create?
    user.manager?
  end

  def update?
    user.manager?
  end

  def destroy?
    user.manager?
  end

  def add_remove_users?
    user.manager?
  end


  class Scope < ApplicationPolicy::Scope
    
  end
end
