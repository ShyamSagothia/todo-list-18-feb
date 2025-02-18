require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TodoListsHelper. For example:
#
# describe TodoListsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TodoListsHelper, type: :helper do
    describe "#format_todo_list" do
    it "returns a formatted todo list string" do
      todo_list = double("TodoList", name: "My Todo List")
      formatted = helper.format_todo_list(todo_list)
      expect(formatted).to eq("My Todo List")
    end
  end
end
