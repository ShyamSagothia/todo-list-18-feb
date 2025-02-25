FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "sa_#{n}@gmail.com"}
    name {"sakshi"}
    password {"123456"}
    password_confirmation {"123456"}
  end
end
