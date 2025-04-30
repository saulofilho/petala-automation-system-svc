# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    subject { build(:order_item) }

    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:product) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:ean_code) }
    it { should validate_presence_of(:status) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      order_item = build(:order_item)
      expect(order_item).to be_valid
    end
  end

  describe 'enums' do
    it 'defines status enums correctly' do
      expect(OrderItem.statuses.keys).to match_array(%w[pending approved denied])
    end
  end
end
