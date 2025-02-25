class TodoListMiniSerializer 
  include Alba::Resource 

  root_key :Data
  
  one :user do
    attributes :id, :email
  end

  attributes :id, :heading

end
  