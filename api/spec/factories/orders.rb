# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    admin_feedback { nil }
    status { 'pending' }
    company
  end
end
