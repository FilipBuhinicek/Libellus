FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "password123" } # automatski postavlja password_digest

    factory :member, class: 'Member' do
      type { 'Member' }
      membership_start { Date.today }
    end

    factory :librarian, class: 'Librarian' do
      type { 'Librarian' }
      employment_date { Date.today }
    end
  end
end
