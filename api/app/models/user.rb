# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :companies

  validates :email, presence: true, uniqueness: true
  validates :name, :cpf, :phone, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin manager promoter] }
  validates :password, length: { minimum: 8 }
  validate :password_complexity


  enum :role, {
    admin: 'admin',
    manager: 'manager',
    promoter: 'promoter'
  }, prefix: :role

  def generate_validation_token
    self.verification_token_sent_at = Time.zone.now
    self.verification_token = SecureRandom.hex(4)
    save(validate: false)
  end

  private

  def password_complexity
    return if password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])/

    errors.add(:password,
               'precisa ter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caracter especial')
  end
end
