# frozen_string_literal: true

class OrderItemSerializer < Panko::Serializer
  attributes :id, :code, :product, :price, :quantity, :ean_code, :status, :admin_feedback, :order_id
end
