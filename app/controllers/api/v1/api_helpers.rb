module API
  module V1
    module ApiHelpers
      def current_user
        @user || User.find(authentication_token: (params[:token] || headers['Authorization-Token'])).first
      end
    end
  end
end
