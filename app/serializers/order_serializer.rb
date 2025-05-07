# frozen_string_literal: true

class OrderSerializer < Panko::Serializer
  attributes :id, :status, :admin_feedback, :company_id
end
