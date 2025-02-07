class BugPolicy < ApplicationPolicy
  def create?
    user.qa?
  end

  def update?
    user.developer? && record.status == "new" && record.developer == user
  end

  def resolve?
     user.developer? && record.status == "started" && record.developer == user
  end

  def destroy?
    user.manager?
  end

  class Scope < ApplicationPolicy::Scope

  end
end
