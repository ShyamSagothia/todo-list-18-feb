class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.includes(todo_lists: :todos).all
    render json: UserSerializer.new(users).serialize, status: :ok
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: UserSerializer.new(user).serialize, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
