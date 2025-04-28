# frozen_string_literal: true

class Order < ApplicationRecord
  validates :name, presence: true
end
