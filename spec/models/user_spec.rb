# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:role) }
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe '#password_complexity' do
    it 'is invalid if password does not meet complexity requirements' do
      user = User.new(password: 'password', password_confirmation: 'password')
      user.valid?
      expect(user.errors[:password]).to include('precisa ter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caracter especial')
    end

    it 'is valid if password meets complexity requirements' do
      user = User.new(password: 'P@ssw0rd', password_confirmation: 'P@ssw0rd')
      user.valid?
      expect(user.errors[:password]).to be_empty
    end
  end

  describe '#generate_validation_token' do
    it 'generates a token and sets verification_token_sent_at' do
      user = create(:user)
      expect(user.verification_token).to be_nil

      user.generate_validation_token

      expect(user.verification_token).to be_present
      expect(user.verification_token_sent_at).to be_within(1.second).of(Time.zone.now)
    end
  end

  describe 'enums' do
    it 'defines role enums correctly' do
      expect(User.roles.keys).to match_array(%w[admin manager promoter])
    end
  end
end
