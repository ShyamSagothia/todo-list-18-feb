class TodoListSerializer
  include Alba::Resource

  attributes :id, :name, :user_id

  # many :todos, resource: TodoSerializer, only: %i[id title done]
  # many :collaborators, resource: CollaboratorSerializer

  attribute :todos, if: proc { params[:detailed] } do |todo_list|
    todo_list.todos.map do |todo|
      {
        id: todo.id,
        title: todo.title,
        done: todo.done
      }
    end
  end

  attribute :collaborators, if: proc { params[:detailed] } do |todo_list|
    todo_list.collaborators.map do |collaborator|
      {
        id: collaborator.id,
        email: collaborator.email
      }
    end
  end
end
