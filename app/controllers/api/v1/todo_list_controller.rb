class Api::V1::TodoListController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:index, :update, :destroy]
  # before_action :find_todo_list, only: %i[show update destroy]

 # before_action :find_user

  def index
    
    # todo_lists = @user.todo_lists
    todo_lists = current_user.todo_lists
    # authorize todo_lists
    render json: { message: "Data fetched successfully", data: todo_lists.as_json(except: [:created_at, :updated_at]) }, status: 200
  end

  def show
    begin
      todo_list = current_user.todo_lists.find(params[:id])
      if todo_list
        # render json: {message: "Data fetched successfully", data: todo_list}, status: 200
        # render json: serializer.new(todo_list), status: 200
        render json: { message: "Data fetched successfully", data: todo_list.as_json(except: [ :created_at, :updated_at ]) }, status: 200
      else
        render json: todo_list.errors, status: bad_request
      end
    rescue => e
      render json: {
        error: e.to_s
      }, status: :not_found
    end
    # authorize @todo_list
    # render json: { message: "Data fetched successfully", data: @todo_list.as_json(except: [:created_at, :updated_at]) }, status: 200
  end

  def create
    todo_list = current_user.todo_lists.create(todo_list_params)
    # authorize todo_list
    if todo_list.valid?
      render json: { message: "Data created successfully", data: todo_list.as_json(except: [:created_at, :updated_at]) }, status: 201
    else
      render json: { errors: todo_list.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    begin
      todo_list = current_user.todo_lists.find(params[:id])
      if todo_list.update!(todo_list_params)
        render json: { message: "Data updated successfully", data: todo_list.as_json(except: [ :created_at, :updated_at ]) }, status: 200
      else
        render json: todo_list.errors, status: unprocessable_entity
      end
    rescue => e
      render json: {
      error: e.to_s
      }, status: :not_found
    end
    # authorize @todo_list
    # if @todo_list.update(todo_list_params)
    #   render json: { message: "Data updated successfully", data: @todo_list.as_json(except: [:created_at, :updated_at]) }, status: 200
    # else
    #   render json: @todo_list.errors, status: :unprocessable_entity
    # end
  end
  

  def destroy
    begin
      todo_list = current_user.todo_lists.find(params[:id])
      if todo_list.destroy!
        render json: { message: "Data deleted successfully" }, status: 200
      else
        render json: todo_list.errors.full_messages, status: bad_request
      end
    rescue => e
      render json: {
        error: e.to_s
      }, status: :not_found
    end
    # if @todo_list.destroy
    #   render json: { message: "Data deleted successfully" }, status: 200
    # else
    #   render json: @todo_list.errors.full_messages, status: :bad_request
    # end
  end

  private

  # def find_todo_list
  #   @todo_list = current_user.todo_lists.find_by(id: params[:id])

  #   if @todo_list.nil?
  #     render json: { error: "Todo list not found" }, status: :not_found
  #   end
  # end

  # def authorize_user
  #   authorize @todo_list
  # end

def authorize_user!
  @todo_list = current_user.todo_lists.find(params[:id])
  unless @todo_list.user == current_user || @todo_list.users.include?(current_user)
    flash[:alert] = "You are not authorized to edit this to-do list."
    # redirect_to root_path
  end
end


  def todo_list_params
    params.require(:todo_list).permit(:heading)
  end
end
