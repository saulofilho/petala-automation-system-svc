FactoryBot.define do
  factory :order do
    name { Faker::Commerce.product_name }
    company
  end
end
