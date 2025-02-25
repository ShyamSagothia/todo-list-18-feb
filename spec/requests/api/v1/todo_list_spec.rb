require 'rails_helper'

RSpec.describe "Api::V1::TodoLists", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:todo_list) {FactoryBot.create(:todo_list, user_id:user.id, heading: "my heading")}
  let(:auth_headers) { user.create_new_auth_token }

  describe "If user is not logged in / unauthorized" do
    
    it "returns a 401 response" do
      get "/api/v1/users/#{user.id}/todo_list"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 response" do
      post "/api/v1/users/#{user.id}/todo_list", params:{todo_list:{heading: "my task"}}
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 response" do
      put "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}", params:{todo_list:{heading:"new Task"}}
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a 401 response" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "Data not found" do

    it "returns id not found" do
      get "/api/v1/users/#{user.id}/todo_list/100", headers:auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it "returns id not found" do
      put "/api/v1/users/#{user.id}/todo_list/100", params:{todo_list: {heading:"New Task"}}, headers:auth_headers
      expect(response).to have_http_status(:not_found)     
    end

    it "returns id not found" do
      delete "/api/v1/users/#{user.id}/todo_list/100", headers:auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "If user is logged in / authorized" do
    
    it "returns a 200 response" do
      get "/api/v1/users/#{user.id}/todo_list", headers:auth_headers
      expect(response).to have_http_status(:ok)
    end

    it "returns a 200 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}", headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

    it "returns a 201 respons" do
      post "/api/v1/users/#{user.id}/todo_list", params: { todo_list: { heading: "first"} }, headers:auth_headers
        expect(response).to have_http_status(:created)
    end

    it "returns a 200 response" do
      put "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}", params: { todo_list: { heading: "first task"} }, headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

    it "returns a 200 response" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}", headers:auth_headers
        expect(response).to have_http_status(:ok)
    end

  end

  describe "If user is logged in / authorized or collaborator" do
    
  end

end
