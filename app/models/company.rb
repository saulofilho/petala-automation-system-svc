# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :orders
  belongs_to :user

  validates :cnpj, presence: true, uniqueness: true
  validates :name, :cep, :street, :number, :city, :state, presence: true
end
