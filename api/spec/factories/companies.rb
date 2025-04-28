FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { Faker::Company.brazilian_company_number }
    cep { Faker::Address.zip_code }
    street { Faker::Address.street_name }
    number { Faker::Address.building_number.to_i }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    user
  end
end
