# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :company
  has_many :order_items

  validates :name, presence: true
end
