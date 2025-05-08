# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    subject { build(:order) }

    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should have_many(:order_items) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      order = build(:order)
      expect(order).to be_valid
    end
  end

  describe 'enums' do
    it 'defines status enums correctly' do
      expect(Order.statuses.keys).to match_array(%w[pending approved denied])
    end
  end
end
