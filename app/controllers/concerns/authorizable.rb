module Authorizable
  extend ActiveSupport::Concern

  private

  def authorize_admin
    authorize :user, :toggle_user?
    authorize :user, :update_user_type?
  end


  def authorize_manager
    authorize Project, :index?
    authorize Project, :create?
    authorize Project, :update?
    authorize Project, :destroy?
    authorize Project, :remove_user?
    authorize Project, :assign_users?
  end


  def authorize_developer
    authorize Bug, :update?
    authorize Bug, :resolve?
  end

  def authorize_qa_project
    authorize Project, :index?
    authorize Project, :show?
  end

  def authorize_qa_bug
    authorize Bug, :create?
  end

  def authorize_developer_project
    authorize Project, :index?
  end

  def authorize_api_project
    authorize Project, :index?
    authorize Project, :show?
  end

  def authorize_api_admin
    authorize :user, :toggle_user?
    authorize :user, :update_user_type?
  end
end
