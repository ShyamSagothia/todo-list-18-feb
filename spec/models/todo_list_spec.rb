require 'rails_helper'

RSpec.describe TodoList, type: :model do
  it "has a valid factory" do
    todo_list = build(:todo_list)
    expect(todo_list).to be_valid
  end

  # it "is valid without the title" do
  #   todo_list = build(:todo_list, title: nil)
  #   expect(todo_list).to_not be_valid
  # end

  it "has many todos" do
    association = described_class.reflect_on_association(:todos)
    expect(association.macro).to eq(:has_many)
  end
end
