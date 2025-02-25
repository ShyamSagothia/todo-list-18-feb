class Api::V1::TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_todo_list

  def index
    @todos = @todo_list.todos
    render json: TodoMiniSerializer.new(@todos).serialize
  end

  def show
    
    todo = @todo_list.todos.find(params[:id])
    authorize todo
    if todo

      render json: TodoDetailedSerializer.new(todo).serialize
    else
      render json: todo.errors, status: bad_request
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def create
    todo = @todo_list.todos.create(todo_params)
    authorize todo
    if todo.valid?
      render json: TodoDetailedSerializer.new(todo).serialize
    else
      render json: { errors: todo.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    todo = policy_scope(Todo).find_by(id: params[:id])
    authorize todo
    if todo.update!(todo_params)
      render json: TodoDetailedSerializer.new(todo).serialize
    else
      render json: todo.errors, status: unprocessable_entity
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def destroy
    todo = policy_scope(Todo).find_by(id: params[:id])
    authorize todo
    if todo.destroy!
      render json: { message: 'Data deleted successfully' }, status: 200
    else
      render json: todo.errors.full_messages, status: bad_request
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def start
    todo = Todo.find(params[:id])
    todo.start!
    render json: TodoDetailedSerializer.new(todo).serialize
  end

  def complete
    todo = Todo.find(params[:id])
    todo.complete!
    render json: TodoDetailedSerializer.new(todo).serialize
  end

  private

  def todo_params
    params.require(:todo).permit(:heading, :content, :status)
  end

  def find_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])
  end
end
