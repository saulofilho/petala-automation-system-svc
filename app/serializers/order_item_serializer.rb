# frozen_string_literal: true

class OrderItemSerializer < Panko::Serializer
  attributes :id, :code, :product, :price, :quantity, :ean_code, :total, :order_id

  def price
    object.price_value
  end

  def total
    object.total_value
  end
end
