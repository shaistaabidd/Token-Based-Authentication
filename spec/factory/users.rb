FactoryBot.define do

    factory :user do
      # name { Faker::Name.name }
      # phone_number { Faker::PhoneNumber.phone_number }
      name { "Shaista"}
      email {"shaista@gmail.com"}
      phone_number {'+18312939010'}
      password {"admin123"}
      password_confirmation {"admin123"}
    end
end