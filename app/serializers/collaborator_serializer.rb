class CollaboratorSerializer

  include Alba::Resource

  root_key :Data
  
  attributes :id, :user_id, :todo_list_id
end
