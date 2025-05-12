FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "password" }
    role { "user" }

    trait :member do
      type { UserType::MEMBER }
      membership_start { Date.today }
    end

    trait :librarian do
      type { UserType::LIBRARIAN }
      employment_date { Date.today }
    end
  end
end
