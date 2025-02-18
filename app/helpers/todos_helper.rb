module TodosHelper
  def format_todo(todo)
    "#{todo.title}: #{todo.description}"
  end
end
