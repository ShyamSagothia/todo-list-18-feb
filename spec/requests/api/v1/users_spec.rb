require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) {FactoryBot.create(:user)}

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/users"
      expect(response).to have_http_status(:success)
    end 
  end

  describe "GET /show" do
    it 'returns a success response' do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end

    it "returns id not found" do
      get "/api/v1/users/100"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do 
    it 'returns a success response' do
      post "/api/v1/users", params: { user: { email: "s@gm.co",  name:"mahi", password:"123456", password_confirmation: "123456" } }
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /update" do
    it 'returns a success response' do
      put "/api/v1/users/#{user.id}", params: { user: { email: "sakshi@gm.co", name:"sakshi", password:"123456", password_confirmation: "123456" } }
      expect(response).to have_http_status(:ok)
    end

    it "returns id not found" do
      put "/api/v1/users/100"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /destroy" do
    it 'returns a success response' do
      delete "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:ok)    
    end

    it "returns id not found" do
      delete "/api/v1/users/100"
      expect(response).to have_http_status(:not_found)
    end
  end
end
