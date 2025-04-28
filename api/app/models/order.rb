# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
end
