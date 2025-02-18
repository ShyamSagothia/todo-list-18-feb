require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
    describe "#full_name" do
    it "concatenates the first and last name of the user" do
      user = double("User", first_name: "John", last_name: "Doe")
      expect(helper.full_name(user)).to eq("John Doe")
    end
  end
end
