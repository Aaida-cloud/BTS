class BugsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_project, except: [:index]
  before_action :set_bug, only: [:edit, :update, :destroy]
  before_action :authorize_bug, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.user_type == 'manager'
      @bugs = Bug.all
    elsif current_user.user_type == 'developer'
    @bugs = Bug.where(developer_id: current_user.id).includes(:project).order(created_at: :desc)
    end
  end

  def new
    @bug = @project.bugs.build
    authorize @bug, :create?
  end

  def create
    @bug = @project.bugs.build(bug_params)
    @bug.qa_id = current_user.id

    if @bug.save
      redirect_to project_path(@project), notice: 'Bug successfully reported.'
    else
      render :new
    end
  end

  def show
    @bug = @project.bugs.find(params[:id])
  end

  def edit
    authorize @bug, :update?
  end

  def update
    if @bug.update(bug_params)
      redirect_to project_path(@bug.project), notice: 'Bug updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    authorize @bug, :destroy?
    @bug.destroy
    redirect_to project_path(@bug.project), notice: 'Bug deleted successfully.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = @project.bugs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to project_path(@project), alert: 'Bug not found or access denied.'
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :project_id, :screenshot).merge(
        bug_type: params[:bug][:bug_type].to_i,
        status: params[:bug][:status].to_i
      )
  end

  def authorize_bug

    authorize @bug, :manage?
    
  end
end
