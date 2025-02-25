class Api::V1::CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_todo_list

  def index
    @collaborators = @todo_list.collaborators
    render json: @collaborators, status: :ok
  end

  def create
    
    binding.pry
    
    if collaborator_params[:user_id].to_i == current_user.id
      return render json: { errors: ["user can not add himself as collaborator"]}, status: :not_acceptable
    end

    @collaborator = @todo_list.collaborators.create(collaborator_params)
    # authorize todo_list
    if @collaborator.valid?
      render json: { message: "Data created successfully", data: @collaborator.as_json(except: [:created_at, :updated_at]) }, status: 201
    else
      render json: { errors: @collaborator.errors.full_messages }, status: :not_acceptable
    end
  end

  def destroy
    begin
      @collaborator = @todo_list.collaborators.find(params[:id])
      if @collaborator.destroy!
        render json: { message: "Data deleted successfully" }, status: 200
      else
          render json: @collaborator.errors.full_messages, status: bad_request
      end
    rescue => e
      render json: {
        error: e.to_s
      }, status: :not_found
    end
  end

  private

  def collaborator_params
      params.require(:collaborator).permit(:user_id)

  end

  def find_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])
    unless @todo_list
      render json: { error: 'Todo list not found' }, status: :not_found
    end
  end

end