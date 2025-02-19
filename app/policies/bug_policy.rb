class BugPolicy < ApplicationPolicy
  def create?
    user.qa?
  end

  def update?
    user.developer? && record.new_bug? && record.developer?
  end

  def resolve?
    user.developer? && record.started? && record.developer == user
  end

  def destroy?
    user.manager?
  end

  class Scope < ApplicationPolicy::Scope

  end
end
