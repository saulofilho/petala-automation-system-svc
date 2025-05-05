# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order

  validates :code, :product, :price, :quantity, :ean_code, presence: true
end
