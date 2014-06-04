module API
  module V1
    module Authorization
      extend ActiveSupport::Concern

      included do
        # HTTP header based authentication
        before do
          unless @user = User.where(authentication_token: (params[:token] || headers['Authorization-Token'])).first
            error!({:error => ErrorList::NOT_AUTHORIZED, :error_message => "Unauthorized"}, 401)
          end
        end
      end
    end
  end
end