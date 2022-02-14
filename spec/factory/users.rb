FactoryBot.define do

    factory :user do
      name { Faker::Name.name }
      phone_number { Faker::PhoneNumber.phone_number }
    end
end