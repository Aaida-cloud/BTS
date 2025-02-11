module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_user!

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'Unauthorized - No Token' }, status: :unauthorized unless token

        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
          @current_user = User.find_by(id: decoded['id'])

          return render json: { error: 'Unauthorized - User Not Found' }, status: :unauthorized unless @current_user
        rescue JWT::DecodeError
          render json: { error: 'Unauthorized - Invalid Token' }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end
    end
  end
end


