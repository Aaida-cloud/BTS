module Api
  module V1
    class ProjectsController < Api::V1::ApplicationController
      before_action :set_user, only: [:assign_users, :remove_user]
      before_action :set_project, only: [:show, :update, :destroy, :assign_users, :remove_user]
      before_action :authorize_api_project, only: [:index, :show]


      def index
        if current_user.manager?
          render json: current_user.created_projects, status: :ok
        else
            render json: 'Unauthorized', status: :unprocessable_entity
        end
      end

      def create
        project = current_user.created_projects.build(project_params)
        if project.save
          render json: { message: "Project created successfully.", project: project }, status: :created
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: { project: @project, bugs: @project.bugs }, status: :ok
      end

      def update
        if @project.update(project_params)
          render json: { message: "Project updated successfully.", project: @project }, status: :ok
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @project.destroy
        render json: { message: "Project deleted successfully." }, status: :ok
      end

      def assign_users
        unless @project.users.include?(user)
          @project.users << user
          render json: { message: "#{user.name} has been added to the project." }, status: :ok
        else
          render json: { error: "#{user.name} is already assigned to this project." }, status: :unprocessable_entity
        end
      end

      def remove_user
        if @project.users.include?(user)
          @project.users.delete(user)
          render json: { message: "#{user.name} has been removed from the project." }, status: :ok
        else
          render json: { error: "#{user.name} is not assigned to this project." }, status: :unprocessable_entity
        end
      end

      private

      def set_project
        @project = Project.find_by(id: params[:id])

        render json: { error: "Project not found or access denied." }, status: :not_found unless @project
      end

      def project_params
        params.require(:project).permit(:name, :description, :deadline)
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
