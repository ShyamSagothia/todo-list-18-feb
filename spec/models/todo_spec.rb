require 'rails_helper'

RSpec.describe Todo, type: :model do
  it "has a valid factory" do
    todo = build(:todo)
    expect(todo).to be_valid
  end

  it "is invalid without a name" do
    todo = build(:todo, title: nil)
    expect(todo).to_not be_valid
  end

  it 'belongs to a todo_list' do
    association = described_class.reflect_on_association(:todo_list)
    expect(association.macro).to eq(:belongs_to)
  end
end
