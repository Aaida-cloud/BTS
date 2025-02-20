class ProjectsController < ApplicationController
  before_action :set_user, only: [:assign_users, :remove_user]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :assign_users, :remove_user]
  before_action :authorize_manager, only: [:index, :create, :update, :destroy, :assign_users, :remove_user]


  def index
    @projects = current_user.created_projects.includes(:bugs, :users).page(params[:page]).per(User::PER_PAGE)
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
    unless @project.users.include?(@user)
      @project.users << @user
      redirect_to projects_path, notice: "#{@user.name} has been added to the project."
    else
      redirect_to projects_path, alert: "#{@user.name} is already assigned to this project."
    end
  end

  def remove_user
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
  end

  def project_params
    params.require(:project).permit(:name, :description, :deadline)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
