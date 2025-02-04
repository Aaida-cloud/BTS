class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :assign_users]

  def index
    @projects = current_user.created_projects
  end

  def new
    @project = current_user.created_projects.build
  end

  def create
    @project = current_user.created_projects.build(project_params)
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

  def assign_users
    @user = User.find(params[:user_id])

    unless @project.users.include?(@user)
      @project.users << @user
      redirect_to projects_path, notice: "#{@user.name} has been added to the project."
    else
      redirect_to projects_path, alert: "#{@user.name} is already assigned to this project."
    end
  end

  def remove_user
  @project = Project.find(params[:id])
  @user = User.find(params[:user_id])

  if @project.users.include?(@user)
    @project.users.delete(@user)
    redirect_to projects_path, notice: "#{@user.name} has been removed from the project."
  else
    redirect_to projects_path, alert: "#{@user.name} is not assigned to this project."
  end
  end


  private

  def set_project
    @project = current_user.created_projects.find(params[:id])
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
