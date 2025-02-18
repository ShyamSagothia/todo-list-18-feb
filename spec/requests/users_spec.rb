# require 'rails_helper'

# RSpec.describe "Users", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end


require 'rails_helper'

describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /users/:id' do
    it 'returns user details' do
      get "/users/#{user.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns error if user not found' do
      get '/users/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
