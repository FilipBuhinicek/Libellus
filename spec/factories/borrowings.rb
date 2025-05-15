FactoryBot.define do
  factory :borrowing do
    borrow_date { Date.today }
    return_date { Date.today + 14 }
    due_date { Date.today + 30 }
    association :book
    association :member, factory: :member
  end
end
