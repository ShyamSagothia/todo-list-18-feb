require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TodosHelper. For example:
#
# describe TodosHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TodosHelper, type: :helper do
    describe "#format_todo" do
      it "formats the todo item" do
        todo = double("Todo", title: "Test Title", description: "Test Description")
        expect(helper.format_todo(todo)).to eq("Test Title: Test Description")
      end
    end
end
