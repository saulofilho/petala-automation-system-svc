# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    description { 'Pedido de Azeitonas' }
    admin_feedback { nil }
    status { 'pending' }
    company
  end
end
