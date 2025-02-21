def auth_headers_for(user)
  token = user.create_new_auth_token # Devise Token Auth method
  {
    'access-token' => token['access-token'],
    'client' => token['client'],
    'uid' => token['uid']
  }
end
