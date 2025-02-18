FactoryBot.define do
  factory :todo do
    title { "Sample Todo" }
    association :todo_list
  end
end
