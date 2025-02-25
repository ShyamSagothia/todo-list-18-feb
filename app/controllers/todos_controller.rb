class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[show update destroy]

  def index
    todos = policy_scope(Todo)
    render json: TodoSerializer.new(todos, params: { detailed: false }).serialize
  end

  def create
    @todo = Todo.new(todo_params)
    authorize @todo

    if @todo.save
      render json: TodoSerializer.new(@todo, params: { detailed: true }).serialize, status: :created
    else
      render json: { error: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    # TODO: = Todo.find_by(id: params[:id])
    if @todo
      authorize @todo
      render json: TodoSerializer.new(@todo, params: { detailed: true }).serialize

    else
      render json: { error: 'Todo not found' }, status: :not_found
    end
  end

  def update
    authorize @todo
    if @todo.update(todo_params)
      render json: TodoSerializer.new(@todo, params: { detailed: true }).serialize
    else
      render json: { error: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @todo
    @todo.destroy
    render json: { message: 'Todo deleted' }
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :done, :todo_list_id)
  end
end
