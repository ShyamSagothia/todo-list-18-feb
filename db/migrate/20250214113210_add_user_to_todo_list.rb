class AddUserToTodoList < ActiveRecord::Migration[8.0]
  def change
    add_reference :todo_lists, :user
  end
end
