module Qa
  class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, only: [:show]
    before_action :authorize_qa_project, only: [:index, :show]


    def index
      @projects = Project.includes(:bugs).page(params[:page]).per(User::PER_PAGE)
    end

    def show
      @bugs = @project.bugs.page(params[:page]).per(User::BUG_PER_PAGE)
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end
  end
end
