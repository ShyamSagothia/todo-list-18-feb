class Api::V1::UsersController < ApplicationController 
  # before_action :authenticate_user!
   # before_action :find_user
   # def index
   #   todos = @user.todos
   #   render json: todos, status: 200
   # end
 
   def index
     users = User.all
     # render json: serializer.new(users).serializable_hash.to_json, status: 200
     render json: users.as_json(except: [:created_at, :updated_at]), status: 200
   end
 
   def show
     begin
       @user= User.find(params[:id])
       if @user
         # render json: @user
         # render json: serializer.new(@user).serializable_hash.to_json, status: 200
         render json: {message: "Data Fetched successfully", data: @user.as_json(except: [:created_at, :updated_at])}, status: 200
       else
         render json: @user.errors
       end
     rescue => e
       render json: {
         error: e.to_s
     }, status: :not_found
     end
   end
 
  #  def create
  #    @user = User.new(user_params)
  #    if @user.save
  #      render json: @user.as_json(except: [:created_at, :updated_at]) , status: :created
  #    else
  #      render json: @user.errors
  #    end
  #  end
 
   def update
     begin
       @user = User.find(params[:id])
       if @user.update!(user_params)
         render json: @user.as_json(except: [:created_at, :updated_at]) , status: :ok
       else
         render json: @user.errors
       end
     rescue => e
       render json:{
         error: e.to_s
       }, status: :not_found
     end
   end
 
   def destroy
     begin
       user = User.find(params[:id])
       user.destroy 
       render json: {"message": "User deleted successfully"}, status: :ok
     rescue => e
       render json:{
         error: e.to_s
       }, status: :not_found
     end
   end
 
   private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end
 
   def serializer
     UserSerializer
   end
   # def find_user
   #   @user = User.find(params[:user_id])
   # end
end
 