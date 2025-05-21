# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order

  validates :code, :product, :price, :quantity, :ean_code, :total, presence: true

  def price_value
    BigDecimal(price || '0')
  rescue ArgumentError
    BigDecimal('0')
  end

  def total_value
    BigDecimal(total || '0')
  rescue ArgumentError
    BigDecimal('0')
  end
end
