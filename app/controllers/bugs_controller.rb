class BugsController < ApplicationController
  include Pundit

  before_action :authenticate_user!
  before_action :authorize_bug, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_bug, only: [:edit, :update, :destroy, :resolve]

  def new
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build
  end

  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build(bug_params)
    # @bug.status = :new_bug
    if @bug.save!
      redirect_to project_path(@bug.project), notice: 'Bug added successfully.'
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
  end


  def edit
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
  end


  def update
    if @bug.update(bug_params)
      redirect_to project_path(@bug.project), notice: 'Bug updated successfully.'
    else
      render :edit
    end
  end

  def resolve
    @bug.status = :resolved
    if @bug.save
      redirect_to project_path(@bug.project), notice: 'Bug marked as resolved.'
    else
      render :show
    end
  end

  def destroy
    @bug.destroy
    redirect_to project_path(@bug.project), notice: 'Bug deleted successfully.'
  end

  private

  def set_bug
    @bug = Bug.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Bug not found or access denied."
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :project_id, screenshots: [])
  end

  def authorize_bug
    if action_name == 'create'
      @bug = Bug.new
      authorize @bug, :create?
    else
      authorize Bug || Bug, :update?
    end
  end
end
