# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :orders

  validates :cnpj, presence: true, uniqueness: true
  validates :name, :cep, :street, :number, :city, :state, presence: true
end
