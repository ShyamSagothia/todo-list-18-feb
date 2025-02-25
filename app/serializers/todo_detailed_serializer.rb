class TodoDetailedSerializer
  include Alba::Resource

  root_key :Data

  one :todo_list do
    attributes :id, :heading
  end

  attributes :id, :heading, :content, :status
end
