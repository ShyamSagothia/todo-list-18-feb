require 'rails_helper'

RSpec.describe TodoListPolicy, type: :policy do
  let(:owner) { create(:user, email: 'owner@example.com') }
  let(:collaborator) { create(:user, email: 'collab@example.com') }
  let(:non_collaborator) { create(:user, email: 'noncollab@example.com') }
  let(:admin) { create(:user, email: 'admin@example.com', admin: true) }
  let(:todo_list) { create(:todo_list, user: owner) }

  before do
    # Add collaborator to the todo_list
    todo_list.collaborators << collaborator
  end

  subject { described_class } # This refers to TodoListPolicy

  describe 'Scope' do
    it "includes owner's todo list" do
      expect(TodoListPolicy::Scope.new(owner, TodoList).resolve).to include(todo_list)
    end

    it "includes collaborator's todo list" do
      expect(TodoListPolicy::Scope.new(collaborator, TodoList).resolve).to include(todo_list)
    end

    it "excludes non-collaborator's todo list" do
      expect(TodoListPolicy::Scope.new(non_collaborator, TodoList).resolve).not_to include(todo_list)
    end
  end

  describe '#show?' do
    it 'allows owner to view the todo list' do
      expect(subject.new(owner, todo_list).show?).to eq(true)
    end

    it 'allows collaborator to view the todo list' do
      expect(subject.new(collaborator, todo_list).show?).to eq(true)
    end

    it 'denies access to non-collaborator' do
      expect(subject.new(non_collaborator, todo_list).show?).to eq(false)
    end

    it 'allows admin to view any todo list' do
      expect(subject.new(admin, todo_list).show?).to eq(true)
    end
  end

  describe '#update?' do
    it 'allows owner to update the todo list' do
      expect(subject.new(owner, todo_list).update?).to eq(true)
    end

    it 'allows admin to update any todo list' do
      expect(subject.new(admin, todo_list).update?).to eq(true)
    end

    it 'denies collaborator from updating the todo list' do
      expect(subject.new(collaborator, todo_list).update?).to eq(false)
    end

    it 'denies non-collaborator from updating the todo list' do
      expect(subject.new(non_collaborator, todo_list).update?).to eq(false)
    end
  end

  describe '#destroy?' do
    it 'allows owner to delete the todo list' do
      expect(subject.new(owner, todo_list).destroy?).to eq(true)
    end

    it 'allows admin to delete any todo list' do
      expect(subject.new(admin, todo_list).destroy?).to eq(true)
    end

    it 'denies collaborator from deleting the todo list' do
      expect(subject.new(collaborator, todo_list).destroy?).to eq(false)
    end

    it 'denies non-collaborator from deleting the todo list' do
      expect(subject.new(non_collaborator, todo_list).destroy?).to eq(false)
    end
  end
end
