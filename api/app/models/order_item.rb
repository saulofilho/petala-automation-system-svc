# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order

  validates :code, :product, :price, :quantity, :ean_code, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved denied] }

  enum :status, {
    pending: 'pending',
    approved: 'approved',
    denied: 'denied'
  }, prefix: :status
end
