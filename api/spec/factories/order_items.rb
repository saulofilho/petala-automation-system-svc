# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    code { Faker::Code.unique.asin }
    product { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 10.0..100.0) }
    quantity { rand(1..10) }
    ean_code { Faker::Code.ean }
    admin_feedback { nil }
    status { 'pending' }
    order
  end
end
