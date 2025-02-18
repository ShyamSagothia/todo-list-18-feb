# Rails.application.routes.draw do
#   mount_devise_token_auth_for "User", at: "auth"
#   resources :users, only: [ :show ]
#   resources :todos, only: [ :index, :create, :update, :destroy ]
#   resources :todo_lists, only: [ :index, :create, :show, :destroy ]
# end


Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"

  resources :users, only: [ :index, :show ]
  resources :todo_lists, only: [ :index, :create, :show, :destroy ]
  resources :todos, only: [ :index, :create, :update, :destroy, :show ]
end

# Rails.application.routes.draw do
#   mount_devise_token_auth_for "User", at: "auth"
#   resources :users do
#     resources :todo_lists do
#       resources :todos
#     end
#   end
# end
