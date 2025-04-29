# frozen_string_literal: true

class OrderSerializer < Panko::Serializer
  attributes :id, :name, :company_id
end
