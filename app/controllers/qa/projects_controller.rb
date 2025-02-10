module Qa
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_qa
    before_action :set_project, only: [:show]

    def index
      @projects = Project.all.page(params[:page]).per(5)
    end

    def show
      @bugs = @project.bugs.page(params[:page]).per(5)
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def authorize_qa
      unless current_user.qa?
        redirect_to root_path, alert: "Access denied. Only QAs can access this page."
      end
    end
  end
end
