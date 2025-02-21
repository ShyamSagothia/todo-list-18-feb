class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list, only: %i[show update destroy]

  def index
    todo_lists = policy_scope(TodoList).includes(:todos)
    render json: todo_lists
  end

  def create
    todo_list = current_user.todo_lists.new(todo_list_params.except(:collaborator_ids))

    todo_list.collaborator_ids = todo_list_params[:collaborator_ids]
    # todo_list = current_user.todo_lists.create(todo_list_params) # todo_list = current_user.todo_lists.create()
    authorize todo_list
    if todo_list.save # todo_list.persisted?
      if todo_list_params[:collaborator_ids].present?
        todo_list_params[:collaborator_ids].each do |collab_id|
          Collaboration.find_or_create_by(user_id: collab_id.to_i, todo_list_id: todo_list.id)
        end
      end

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
      render json: { error: 'Todo List not found' }, status: :not_found
    end
  end

  def update
    authorize @todo_list
    if @todo_list.update(todo_list_params)
      render json: @todo_list
    else
      render json: { error: @todo_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # todo_list = current_user.todo_lists.find_by(id: params[:id])
    authorize @todo_list
    if @todo_list.destroy
      render json: { message: 'Todo List deleted' }
    else
      render json: { error: 'Unable to delete Todo List' }, status: :unprocessable_entity
    end
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:id])
    # @todo_list = (current_user.admin? ? TodoList : current_user.todo_lists).find_by(id: params[:id])
    render json: { error: 'Todo List not found' }, status: :not_found unless @todo_list
  end

  def todo_list_params
    params.require(:todo_list).permit(:name, collaborator_ids: [])
    # params.require(:todo_list).permit(:name, todos_attributes: %i[title description done])
  end
end
