class AddTodoListIdToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :todo_list_id, :integer
    add_index :todos, :todo_list_id
  end
end
