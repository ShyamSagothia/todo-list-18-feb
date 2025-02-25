require 'rails_helper'

RSpec.describe Todo, type: :model do
  todo = FactoryBot.build(:todo)
  describe '#validations' do
  
    it 'has an invalid heading' do
      todo.heading = ''
      expect(todo).not_to be_valid
      expect(todo.errors[:heading]).to include("can't be blank")
    end

    it 'has an invalid content' do
      todo.content = ''
      expect(todo).not_to be_valid
      expect(todo.errors[:content]).to include("can't be blank")
    end

    it 'validate the length of heading' do
      todo.heading = 'hello'
      expect((todo[:heading]).length).to be > 3
    end

    it 'validiate the length of content' do
      todo.content = 'hello'
      expect((todo[:content]).length).to be >= 5
    end
  end

  describe "Association" do
    
    # it "should associated with todo list(belongs to)" do
    #   todo_list = TodoList.reflect_on_association(:todo)
    #   expect(todo_list.macro).to eq(:belong_to)
    # end

    it{ should belong_to(:todo_list)}
  end
end
