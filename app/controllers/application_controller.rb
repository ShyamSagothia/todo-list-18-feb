class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include Pundit::Authorization
        # after_action :verify_authorized

end
