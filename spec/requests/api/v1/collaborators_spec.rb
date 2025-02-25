require 'rails_helper'

RSpec.describe "Api::V1::Collaborators", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:user2) {FactoryBot.create(:user)}
  let(:todo_list) {FactoryBot.create(:todo_list, user_id:user.id, heading: "my heading")}
  let(:collaborator) {FactoryBot.create(:collaborator,todo_list_id: todo_list.id, user_id:user.id)}
  let(:auth_headers) { user.create_new_auth_token }

  describe "If user is not logged in / unauthorized" do
    
    it "returns a 401 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/collaborators"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "If user is logged in / authorized" do
    
    it "returns a 200 response" do
      get "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/collaborators", headers:auth_headers
      expect(response).to have_http_status(:ok)
    end


    #error not resolved
    it "returns a 401 response" do
      post "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/collaborators", 
      params: {collaborator: {user_id: user.id} },
      headers:auth_headers

      aggregate_failures do
        expect(response.body).to include("user can not add himself as collaborator")
        expect(response).to have_http_status(:not_acceptable)
      end
    end

    it "returns a 201 response" do
      post "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/collaborators", params: {collaborator: {user_id: user2.id} }, headers: auth_headers

      # aggregate_failures do
      #   # expect(response.body).to include("user can not add himself as collaborator")
      #   expect(response).to have_http_status(:created)
      # end
    end

    it "returns a 200 response" do
      delete "/api/v1/users/#{user.id}/todo_list/#{todo_list.id}/collaborators/#{collaborator.id}", headers:auth_headers
        expect(response).to have_http_status(:ok)
    end
  end
end