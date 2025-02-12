class BugsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_bug

  def index
    @bugs = Bug.all.includes(:developer)
  end

  def show
    @bug = @project.bugs.find(params[:id])
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = @project.bugs.find(params[:id])
  end
end
