# require 'rails_helper'

# RSpec.describe "TodoLists", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end



require 'rails_helper'

describe 'TodoLists API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /todo_lists' do
    it 'returns a list of todo lists' do
      get '/todo_lists', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /todo_lists' do
    it 'creates a new todo list' do
      post '/todo_lists', params: { todo_list: { name: 'My Tasks', todos_attributes: [] } }, headers: auth_headers
      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET /todo_lists/:id' do
    let(:todo_list) { create(:todo_list, user: user) }
    it 'returns a specific todo list' do
      get "/todo_lists/#{todo_list.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /todo_lists/:id' do
    let(:todo_list) { create(:todo_list, user: user) }
    it 'deletes a todo list' do
      delete "/todo_lists/#{todo_list.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
