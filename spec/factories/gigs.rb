FactoryBot.define do
  factory :gig do
    name { "Web Development"}
    description {"Will develop amazing websites for you"}
    amount { "9.99" }
    review_count { 1 }
    average_star { "78" }
  end
end
