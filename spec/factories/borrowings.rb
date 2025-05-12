FactoryBot.define do
  factory :borrowing do
    borrow_date { Date.today }
    return_date { Date.today + 30 }
    association :book
    association :member, factory: [ :user, :member ]
  end
end
