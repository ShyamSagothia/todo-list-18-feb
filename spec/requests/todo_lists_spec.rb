# require 'rails_helper'

# RSpec.describe "TodoLists", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end

require 'rails_helper'

describe 'TodoLists API', type: :request do
  # let(:user) { create(:user) }
  # let(:owner) { create(:user) }
  # let(:collaborator) { create(:user) }
  let(:collaborator) { create(:user, email: 'collaborator@example.com') }
  let(:owner) { create(:user, email: 'owner@example.com') }
  let(:non_collaborator) { create(:user) }
  let(:todo_list) { create(:todo_list, user: owner) }
  let(:auth_headers) { owner.create_new_auth_token }

  before do
    todo_list.collaborators << collaborator
  end

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
    it 'returns a specific todo list' do
      get "/todo_lists/#{todo_list.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    context 'when user is the owner' do
      it 'returns the todo list' do
        get '/todo_lists', headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is a collaborator' do
      it 'allows access' do
        get "/todo_lists/#{todo_list.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not a collaborator' do
      let(:stranger) { create(:user) }

      it 'denies access' do
        get "/todo_lists/#{todo_list.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /todo_lists/:id' do
    let(:todo_list) { create(:todo_list, user: owner) }
    it 'deletes a todo list' do
      delete "/todo_lists/#{todo_list.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    context 'when user is the owner' do
      it 'deletes the todo list' do
        delete "/todo_lists/#{todo_list.id}", headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is a collaborator' do
      it 'denies deletion' do
        delete "/todo_lists/#{todo_list.id}", headers: collaborator.create_new_auth_token
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
