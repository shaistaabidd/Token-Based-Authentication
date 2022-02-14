FactoryBot.define do
  factory :gig do
    name { "MyString" }
    description { "MyText" }
    amount { "9.99" }
    review_count { 1 }
    average_star { "MyString" }
  end
end
