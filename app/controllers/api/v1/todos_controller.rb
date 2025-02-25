class Api::V1::TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_todo_list

  def index

    @todos = @todo_list.todos
    render json: @todos, status: :ok
    # todos = @todo_list.todos
    # render json: { message: "Data fetched successfully", data: todos.as_json(except: [ :created_at, :updated_at ]) }, status: 200
  end

  def show
    begin
      todo = Todo.find(params[:id])
      Rails.logger.debug "Data?#{todo.to_json}"
      
      Rails.logger.debug "Data after authori.?#{todo.to_json}"
      if todo
        render json: { message: "Data fetched successfully", data: todo.as_json(except: [ :created_at, :updated_at ]) }, status: 200
        # render json: serializer.new(todo), status: 200
      else
        render json: todo.errors, status: bad_request
      end
    rescue => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end

  def create
    # todo = Todo.new(todo_params.merge(todo_list_id: @todo_list))
    todo = @todo_list.todos.create(todo_params)
    authorize todo
    if todo.valid?
      render json: { message: "Data created successfully", data: todo.as_json(except: [ :created_at, :updated_at ]) }, status: 201
    else
      render json: { errors: todo.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    begin
      # todo = @todo_list.todos.find(params[:id])
      # todo = policy_scope(Todo).find(params[:id])
      todo = policy_scope(Todo).find_by(id: params[:id])

      Rails.logger.debug "Data1?#{todo.to_json}"
      authorize todo
      Rails.logger.debug "Data2?#{todo.to_json}"
      if todo.update!(todo_params)
        render json: { message: "Data updated successfully", data: todo.as_json(except: [ :created_at, :updated_at ]) }, status: 200
      else
        render json: todo.errors, status: unprocessable_entity
      end
    rescue => e
        render json: {
          error: e.to_s
      }, status: :not_found
    end
  end

  def destroy
    begin
      # todo = Todo.find(params[:id])
      todo = policy_scope(Todo).find_by(id: params[:id])
      authorize todo
      if todo.destroy!
          render json: { message: "Data deleted successfully" }, status: 200
      else
          render json: todo.errors.full_messages, status: bad_request
      end
    rescue => e
        render json: {
          error: e.to_s
        }, status: :not_found
    end
  end

  def start
    todo = Todo.find(params[:id])
    todo.start!
    render json: { message: "Todo started successfully", data: todo.as_json(except: [ :created_at, :updated_at ]) }, status: 200
  end

  def complete
    todo = Todo.find(params[:id])
    todo.complete!
    render json: { message: "Todo completed successfully", data: todo.as_json(except: [ :created_at, :updated_at ]) }, status: 200
  end
  
  private
  def todo_params
    params.require(:todo).permit(:heading, :content, :status)
  end

  def find_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])
  end

  def serializer
    TodoSerializer
  end
end
