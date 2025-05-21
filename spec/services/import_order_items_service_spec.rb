# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportOrderItemsService, type: :service do
  let(:order) { create(:order) }
  let(:sheet) { double('sheet', last_row: last_row) }
  let(:last_row) { 3 }

  let(:header_row) { %w[Código Produto Preço Qtd Total EAN] }
  let(:valid_row)  { ['123', 'Product A', '10.5', '2', '21.0', '456'] }
  let(:blank_row)  { ['',    '', '', '', '', ''] }

  before do
    allow(sheet).to receive(:row).with(1).and_return(header_row)
    allow(sheet).to receive(:row).with(2).and_return(valid_row)
    allow(sheet).to receive(:row).with(3).and_return(blank_row)
  end

  subject(:result) { described_class.new(order, sheet).call }

  describe 'importing order items' do
    it 'imports valid rows successfully' do
      expect { result }.to change { order.order_items.count }.by(1)
      expect(result[:imported]).to eq(1)
      expect(result[:errors]).to be_empty
    end

    context 'when a row fails to save' do
      before do
        allow_any_instance_of(OrderItem).to receive(:save).and_return(false)
        allow_any_instance_of(OrderItem)
          .to receive_message_chain(:errors, :full_messages)
          .and_return(['Invalid data'])
      end

      it 'does not import the invalid row and collects errors' do
        expect { result }.not_to(change { order.order_items.count })
        expect(result[:imported]).to eq(0)
        expect(result[:errors]).to eq([{ row: 2, messages: ['Invalid data'] }])
      end
    end
  end
end
