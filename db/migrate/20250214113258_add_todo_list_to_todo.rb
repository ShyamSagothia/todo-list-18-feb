class AddTodoListToTodo < ActiveRecord::Migration[8.0]
  def change
    add_reference :todos, :todo_list, null: false, foreign_key: true
  end
end
