require 'rails_helper'

RSpec.describe Collaborator, type: :model do

  describe "Association" do
    
    it{ should belong_to(:user)}

    it{ should belong_to(:todo_list)}
  end
end
