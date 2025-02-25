class TodoSerializer
  include Alba::Resource
  attributes :id, :title, :description, :done, :todo_list_id
end
