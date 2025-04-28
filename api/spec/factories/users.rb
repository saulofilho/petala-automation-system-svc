FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'Teste@123' }
    name { Faker::Name.name }
    cpf { Faker::IdNumber.brazilian_citizen_number }
    phone { Faker::PhoneNumber.phone_number }
    role { %w[admin manager promoter].sample }
  end
end
