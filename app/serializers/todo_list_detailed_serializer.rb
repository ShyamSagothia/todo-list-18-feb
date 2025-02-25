class TodoListDetailedSerializer 
  include Alba::Resource 

  root_key :Data

  attributes :id, :heading

  one :user do
    attributes :id, :email
  end
  
  many :collaborators do
    attributes :id, :user_id
  end

end
  