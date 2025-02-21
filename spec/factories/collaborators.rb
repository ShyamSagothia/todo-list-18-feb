FactoryBot.define do
  factory :collaborator do
    sequence(:user_id) {|n| "#{n}"}
    sequence(:todo_list_id) { |n| "#{n}" }
  end
end
