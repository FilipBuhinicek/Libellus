FactoryBot.define do
  factory :reservation do
    reservation_date { Date.today }
    expiration_date { Date.today + 7 }
    association :book
    association :user, factory: [ :user, :member ]
  end
end
