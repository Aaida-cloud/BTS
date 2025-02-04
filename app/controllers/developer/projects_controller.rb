module Developer
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_developer
    before_action :set_project, only: [:show, :assign_bug_to_me, :unassign_bug]

    def index
      @projects = current_user.projects
    end

    def show
      @bugs = @project.bugs || []
    end

    def assign_bug_to_me
      # Find the bug by id
      @bug = Bug.find(params[:bug_id])
      if @bug.update(developer: current_user) # Assign the bug to the current user (manager)
        redirect_to developer_project_path(@project), notice: "Bug assigned to you."
      else
        redirect_to developer_project_path(@project), alert: "Error assigning bug."
      end
    end

    def unassign_bug
      # Find the bug by id
      @bug = Bug.find(params[:bug_id])
      if @bug.update(developer: nil) # Unassign the bug
        redirect_to developer_project_path(@project), notice: "Bug unassigned."
      else
        redirect_to developer_project_path(@project), alert: "Error unassigning bug."
      end
    end

    private

    def set_project
      @project = Project.find_by(id: params[:id])
      redirect_to developer_projects_path, alert: "Project not found." if @project.nil?
    end

    def authorize_developer
      unless current_user.developer? || current_user.manager?
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end
