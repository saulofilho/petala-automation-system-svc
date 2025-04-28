# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    subject { build(:order) }

    it { should validate_presence_of(:name) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      order = build(:order)
      expect(order).to be_valid
    end
  end
end
