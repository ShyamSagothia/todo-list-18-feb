require 'rails_helper'
RSpec.describe "Api::V1::Todos", type: :request do
  
  let(:user) { FactoryBot.create(:user) }
  let(:todo_list) {FactoryBot.create(:todo_list, user_id:user.id)}
  let(:collaborator){FactoryBot.create(todo_list_id:todo_list.id, user_id:user.id)}
  let(:todo) {FactoryBot.create(:todo, todo_list_id:todo_list.id)}
  let(:auth_headers) { user.create_new_auth_token }

  describe "If user is not logged in / unauthorized" do

    it "returns a 401 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}"
        expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 respons" do
      post "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos", params: { todo: { heading: "first", content: "My first task" } }
        expect(response).to have_http_status(:unauthorized)
    end       

    it "returns a 401 response" do
      put "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}", params: { todo: { heading: "first task", content: "My first task again" } }
      aggregate_failures do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    it "returns a 401 response" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}"
      aggregate_failures do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  describe "If user is logged in / authorized" do
    
    it "returns a 200 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos", headers:auth_headers
      expect(response).to have_http_status(:ok)
    end

    it "returns a 200 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}", headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

    it "returns a 201 respons" do
      post "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos", params: { todo: { heading: "first", content: "My first task" } }, headers:auth_headers
        expect(response).to have_http_status(:created)
    end

    it "returns a 200 response" do
      put "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}", params: { todo: { heading: "first task", content: "My first task again" } }, headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

    it "returns a 200 response" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/#{todo.id}", headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

  end

  describe "If user is logged in / authorized or collaborator" do
 
  end

  describe "Data not found" do
    
    it "returns id not found" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/100", headers:auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it "returns id not found" do
      put "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/100", params: { todo: { heading: "first task", content: "My first task again" } }, headers:auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it "returns id not found" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/todos/100", headers:auth_headers
      expect(response).to have_http_status(:not_found)
    end 
  end

end
