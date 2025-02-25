class Api::V1::TodoListController < ApplicationController
  before_action :authenticate_user!

  def index

    # @todo_lists = current_user.todo_lists.find(params[:id])
    # @todo_list = TodoList.find(params[:id])

    @todo_lists = policy_scope(TodoList)
    Rails.logger.debug "Data?#{@todo_lists.to_json}"
    render json: @todo_lists

  end

  def show
    begin
      @todo_list = policy_scope(TodoList).find(params[:id])
      authorize @todo_list
      render json: @todo_list
      # @todo_list = TodoList.find(params[:id])
      # authorize @todo_list
      # if todo_list
      #   # render json: {message: "Data fetched successfully", data: todo_list}, status: 200
      #   # render json: serializer.new(todo_list), status: 200
      #   render json: { message: "Data fetched successfully", data: todo_list.as_json(except: [ :created_at, :updated_at ]) }, status: 200
      # else
      #   render json: todo_list.errors, status: bad_request
      # end
    rescue => e
      render json: {
        error: e.to_s
      }, status: :not_found
    end
  end

  def create
    Rails.logger.debug "Is current user ? #{current_user.inspect}"
     todo_list = TodoList.new(todo_list_params.merge(user_id: current_user.id))
      # todo_list = policy_scope(TodoList).new(todo_list_params)
      # Rails.logger.debug "Is todo_list ? #{current_user.todo_lists}"
      Rails.logger.debug "Is todo_list before authorization ? #{todo_list.inspect}"

      authorize todo_list
      Rails.logger.debug "Is todo_list after authorization? #{todo_list.inspect}"
      if todo_list.save && todo_list.valid?
        render json: { message: "Data created successfully", data: todo_list.as_json(except: [:created_at, :updated_at]) }, status: 201
      else
        render json: { errors: todo_list.errors.full_messages }, status: :not_acceptable
      end
  end

  def update
    begin
      @todo_list = policy_scope(TodoList).find(params[:id])
      authorize @todo_list
      if @todo_list.update!(todo_list_params)
        render json: { message: "Data updated successfully", data: @todo_list.as_json(except: [ :created_at, :updated_at ]) }, status: 200
      else
        render json: @todo_list.errors, status: unprocessable_entity
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
      @todo_list = policy_scope(TodoList).find(params[:id])
      authorize @todo_list
      if @todo_list.destroy!
        render json: { message: "Data deleted successfully" }, status: 200
      else
        render json: @todo_list.errors.full_messages, status: bad_request
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

  def find_todo_list
    @todo_list = TodoList.find(params[:id])
    if @todo_list.nil?
      render json: { error: "Todo list not found" }, status: :not_found
    end
  end
  # def authorize_user
  #   authorize @todo_list
  # end


  def todo_list_params
    params.require(:todo_list).permit(:heading)
  end
end
