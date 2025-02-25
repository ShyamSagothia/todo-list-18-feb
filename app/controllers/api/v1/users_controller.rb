class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: UserSerializer.new(users).serialize
  end

  def show
    @user = User.find(params[:id])
    if @user
      render json: @user, status: 200, serializer: UserSerializer
    else
      render json: @user.errors
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { "message": 'User deleted successfully' }, status: :ok
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
