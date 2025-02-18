# require 'rails_helper'

# RSpec.describe "Todos", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end

require 'rails_helper'

describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /todos' do
    it 'returns a list of todos' do
      get '/todos', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /todos' do
    it 'creates a new todo' do
      post '/todos', params: { todo: { title: 'Test', description: 'Test Desc', done: 'false', todo_list_id: "1" } }, headers: auth_headers
      expect(response).to have_http_status(404)
    end
  end
end
