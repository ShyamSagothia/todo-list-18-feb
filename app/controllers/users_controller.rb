class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.includes(todo_lists: :todos).all
    render json: users.as_json(includes: { todo_lists: { include: :todos } })
  end
  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
