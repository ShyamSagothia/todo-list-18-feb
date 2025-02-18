class TodoListsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :set_todo_list, only: [ :show, :destroy ]


  def index
    todo_lists = policy_scope(current_user.todo_lists.includes(:todos))
    render json: todo_lists
  end

  def create
    todo_list = current_user.todo_lists.create(todo_list_params)
    authorize todo_list
    if todo_list.persisted?
      render json: todo_list, status: :created
    else
      render json: { error: todo_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    # todo_list = current_user.todo_lists.includes(:todos).find_by(id: params[:id])
    authorize @todo_list
    if @todo_list
      render json: @todo_list
    else
      render json: { error: "Todo List not found" }, status: :not_found
    end
  end

  def destroy
    # todo_list = current_user.todo_lists.find_by(id: params[:id])
    authorize @todo_list
    if @todo_list&.destroy
      render json: { message: "Todo List deleted" }
    else
      render json: { error: "Todo List not found" }, status: :not_found
    end
  end

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find_by(id: params[:id])
    return if @todo_list.present?
    render json: { error: "Todo List not found" }, status: :not_found
  end

  def todo_list_params
    params.require(:todo_list).permit(:name, todos_attributes: [ :title, :description, :done ])
  end
end
