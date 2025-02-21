class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization
  skip_before_action :verify_authenticity_token

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: 'you are not authorized to perform this action ' }, status: :unauthorized
  end
end
