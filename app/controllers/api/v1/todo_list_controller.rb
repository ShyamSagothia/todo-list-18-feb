class Api::V1::TodoListController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = policy_scope(TodoList)
    render json: TodoListMiniSerializer.new(@todo_lists).serialize
  end

  def show
    @todo_list = policy_scope(TodoList).find(params[:id])
    authorize @todo_list
    render json: TodoListDetailedSerializer.new(@todo_list).serialize
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def create
    todo_list = TodoList.new(todo_list_params.merge(user_id: current_user.id))
    authorize todo_list
    if todo_list.save && todo_list.valid?
      render json: todo_list, status: 201, serializer: TodoListSerializer
    else
      render json: { errors: todo_list.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    @todo_list = policy_scope(TodoList).find(params[:id])
    authorize @todo_list
    if @todo_list.update!(todo_list_params)
      render json: @todo_list, status: 200, serializer: TodoListSerializer
    else
      render json: @todo_list.errors, status: unprocessable_entity
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def destroy
    @todo_list = policy_scope(TodoList).find(params[:id])
    authorize @todo_list
    if @todo_list.destroy!
      render json: { message: 'Data deleted successfully' }, status: 200
    else
      render json: @todo_list.errors.full_messages, status: bad_request
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  private

  def find_todo_list
    @todo_list = TodoList.find(params[:id])
    return unless @todo_list.nil?

    render json: { error: 'Todo list not found' }, status: :not_found
  end

  def todo_list_params
    params.require(:todo_list).permit(:heading)
  end
end
