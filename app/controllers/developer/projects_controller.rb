module Developer
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_developer
    before_action :set_project, only: [:show, :bug_details, :update_bug_status]
    before_action :set_bug, only: [:update_bug_status, :bug_details]

    def index
      @projects = current_user.projects
    end

    def show
      @project = Project.find(params[:id])
    end

    def update_bug_status
      @bug = Bug.find(params[:bug_id])
      if current_user.developer? && @bug.update(status: params[:status], developer_id: current_user.id)
        flash[:success] = "Bug status updated successfully!"
      else
        flash[:error] = "Oops! Something went wrong or you don't have permission."
      end

      redirect_to developer_project_path(@project)
    end

    def bug_details
      @project = Project.find(params[:id])
      @bug = Bug.find(params[:bug_id])
    end

    private

    def set_bug
      @bug = Bug.find(params[:bug_id])
    end

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
