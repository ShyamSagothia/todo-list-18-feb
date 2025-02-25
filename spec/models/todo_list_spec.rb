require 'rails_helper'

RSpec.describe TodoList, type: :model do
  todo_list = FactoryBot.build(:todo_list)

  describe '#validations' do
  
    it 'has an invalid heading' do
      todo_list.heading = ''
      expect(todo_list).not_to be_valid
      expect(todo_list.errors[:heading]).to include("can't be blank")
    end

    it 'has an invalid user' do
      todo_list.user = nil
      expect(todo_list).not_to be_valid
      expect(todo_list.errors[:user]).to include("can't be blank")
    end
  end

  describe "Association" do
    
    it{ should belong_to(:user)}

    it "should associated with todo(has many)" do
      todo_list = TodoList.reflect_on_association(:todos)
      expect(todo_list.macro).to eq(:has_many)
    end

    it "has many:through association" do
      expect(subject).to have_many(:collaborators_users).through(:collaborators).source(:user)
    end

    #issue not resolved
    it "should associated with collaborators(has_many)" do
      collab = Collaborator.reflect_on_association(:collaborators)
      expect(collab.macro).to eq(:has_many)
    end

    it { should has_many(:collaborators) }


  end
end
