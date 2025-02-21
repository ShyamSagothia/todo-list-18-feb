require 'rails_helper'

RSpec.describe TodoListPolicy, type: :policy do
  let(:user) { User.new }
  let(:todo_list){}

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

end
