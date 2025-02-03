class ProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_manager, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to projects_path, notice: 'Project created successfully.'
    else
      render :new
    end
  end

  def show
    @bugs = @project.bugs
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'Project updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project deleted successfully.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found or access denied."
  end

  def project_params
    params.require(:project).permit(:name, :description, :deadline)
  end

  def authorize_manager
    unless current_user.manager?
      redirect_to root_path, alert: "Access denied. Only managers can access this page."
    end
  end
end
