class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  # validates :role, presence: true, inclusion: { in: %w[patient psychologist] }
  validates :password, length: { minimum: 8 }
  validate :password_complexity

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

  # enum role: {
  #   admin: 'admin',
  #   manager: 'manager',
  #   promoter: 'promoter'
  # }, _prefix: :role
end
