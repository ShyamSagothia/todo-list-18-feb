FactoryBot.define do
  factory :todo_list do
    name { "Sample Todo List" }
    association :user
  end
end
