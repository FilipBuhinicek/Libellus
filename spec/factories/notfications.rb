FactoryBot.define do
  factory :notification do
    title { "Reminder" }
    content { "Your book is due in 3 days." }
    sent_date { Date.today }
    association :member, factory: :member
  end
end
