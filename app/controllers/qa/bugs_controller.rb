module Qa
  class BugsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_qa
    before_action :set_project, only: [:new, :create]

    def new
      @bug = @project.bugs.new
      authorize @bug, :create?
    end

    def create
      @bug = @project.bugs.new(bug_params)
      @bug.qa_id = current_user.id
      if @bug.save
        redirect_to qa_project_path(@project), notice: 'Bug was successfully reported.'
      else
        render :new
      end
    end

    def show
      @bug = @project.bugs.find_by(id: params[:id])
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def bug_params
      params.require(:bug).permit(:title, :description, :bug_type, :status, :deadline, :screenshot)
    end

    def authorize_qa
      unless current_user.qa?
        redirect_to root_path, alert: "Access denied. Only QAs can access this page."
      end
    end
  end
end
