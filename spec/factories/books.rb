FactoryBot.define do
  factory :book do
    title { "1984" }
    published_year { 1949 }
    description { "A dystopian social science fiction novel and cautionary tale." }
    book_type { "Fiction" }
    copies_available { 3 }
    association :author
  end
end
