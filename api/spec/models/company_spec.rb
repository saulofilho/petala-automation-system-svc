# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations' do
    subject { build(:company) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cep) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
  end

  describe 'associations' do
    it { should have_many(:orders) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      company = build(:company)
      expect(company).to be_valid
    end
  end
end
