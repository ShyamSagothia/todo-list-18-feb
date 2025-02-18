class TodosController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :authenticate_user!

  def index
    render json: current_user.todos
  end

  def create
    todo_list = current_user.todo_lists.find(params[:todo][:todo_list_id])
    todo = todo_list.todos.new(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    todo = Todo.find_by(id: params[:id])
    if todo
      render json: todo
    else
      render json: { error: "Todo not found" }, status: :not_found
    end
  end

  def update
    todo = current_user.todos.find_by(id: params[:id])
    if todo&.update(todo_params)
      render json: todo
    else
      render json: { error: "Todo not found or update failed" }, status: :unprocessable_entity
    end
  end

  def destroy
    todo = current_user.todos.find_by(id: params[:id])
    if todo&.destroy
      render json: { message: "Todo deleted" }
    else
      render json: { error: "Todo not found" }, status: :not_found
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :done, :todo_list_id)
  end
end
