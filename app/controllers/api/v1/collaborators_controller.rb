class Api::V1::CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_todo_list

  def index
    @collaborators = @todo_list.collaborators
    render json: CollaboratorSerializer.new(@collaborators).serialize
  end

  def create
    if collaborator_params[:user_id].to_i == current_user.id
      return render json: { errors: ['user can not add himself as collaborator'] }, status: :not_acceptable
    end

    @collaborator = @todo_list.collaborators.new(collaborator_params)
    
    if @collaborator.save! && @collaborator.valid?
      render json: { message: 'Data created successfully', data: @collaborator }, status: 201
    else
      render json: { errors: @collaborator.errors.full_messages }, status: :not_acceptable
    end
  end

  def destroy
    @collaborator = @todo_list.collaborators.find(params[:id])
    if @collaborator.destroy!
      render json: { message: 'Data deleted successfully' }, status: 200
    else
      render json: @collaborator.errors.full_messages, status: bad_request
    end
  rescue StandardError => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  private

  def collaborator_params
    params.require(:collaborator).permit(:user_id)
  end

  def find_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])
    return if @todo_list
    render json: { error: 'Todo list not found' }, status: :not_found
  end
end
