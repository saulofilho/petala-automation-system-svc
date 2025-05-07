# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :company
  has_many :order_items

  validates :status, presence: true, inclusion: { in: %w[pending approved denied] }

  enum :status, {
    pending: 'pending',
    approved: 'approved',
    denied: 'denied'
  }, prefix: :status
end
