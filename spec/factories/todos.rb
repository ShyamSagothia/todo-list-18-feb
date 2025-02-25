FactoryBot.define do
  factory :todo do
    sequence(:heading) { |n| "heading-#{n}" }
    sequence(:content) { |n| "content-#{n}" }
    # todo_list_id{"1"}

    # heading { "heading" }
    # content { "content" }
  end
end