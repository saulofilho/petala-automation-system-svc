# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderPdf, type: :prawn do
  let(:company) { create(:company, name: 'ACME Ltda') }
  let(:order)   { create(:order, id: 42, company: company, created_at: Time.new(2025, 5, 20, 14, 35)) }

  before do
    create(:order_item, order: order, product: 'Produto X', code: 'X123', price: 15.0, quantity: 2, ean_code: 'E01')
    create(:order_item, order: order, product: 'Produto Y', code: 'Y456', price: 20.5, quantity: 1, ean_code: 'E02')
  end

  describe 'header and details' do
    let(:pdf) do
      pdf = described_class.allocate
      allow(pdf).to receive(:text)
      allow(pdf).to receive(:stroke_horizontal_rule)
      allow(pdf).to receive(:move_down)
      pdf.send(:initialize, order)
      pdf
    end

    it 'outputs the header with order number and draws a rule' do
      expect(pdf).to have_received(:text).with("Pedido #42", size: 24, style: :bold, align: :center)
      expect(pdf).to have_received(:stroke_horizontal_rule)
    end

    it 'outputs order details' do
      expect(pdf).to have_received(:text).with("Cliente: ACME Ltda")
      expect(pdf).to have_received(:text).with("Data do Pedido: 20/05/2025 14:35")
    end
  end

  describe '#item_rows' do
    it 'builds an array with header and item rows' do
      rows = OrderPdf.new(order).send(:item_rows)
      expect(rows.first).to eq(['#', 'Produto', 'Code', 'Preço Unitário', 'Quantidade', 'EAN Code', 'Ordem ID'])

      item1 = rows[1]
      expect(item1[0]).to eq(1)
      expect(item1[1]).to eq('Produto X')
      expect(item1[2]).to eq('X123')
      expect(item1[3]).to eq('15.00')
      expect(item1[4]).to eq(2)
      expect(item1[5]).to eq('E01')
      expect(item1[6]).to eq(order.id)
      expect(rows.size).to eq(order.order_items.count + 1)
    end
  end
end
