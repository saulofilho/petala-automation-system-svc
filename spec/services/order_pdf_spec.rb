# spec/services/order_pdf_spec.rb
require 'rails_helper'

# RSpec.describe OrderPdf, type: :service do
#   let(:company) { create(:company, name: "ACME Corp") }
#   let(:order) do
#     create(
#       :order,
#       company: company,
#       created_at: Time.zone.local(2025, 5, 13, 15, 0)
#     )
#   end
#   let!(:items) do
#     create_list(
#       :order_item,
#       2,
#       order: order,
#       product_name: "Produto X",
#       quantity: 2,
#       unit_price: 25.0
#     )
#   end

#   subject(:pdf) { described_class.new(order) }

#   describe "#render" do
#     it "começa com o header PDF" do
#       expect(pdf.render.byteslice(0, 4)).to eq "%PDF"
#     end

#     it "inclui o número do pedido e o nome da empresa" do
#       content = pdf.render
#       expect(content).to include("Pedido ##{order.id}")
#       expect(content).to include(company.name)
#     end

#     it "lista todas as linhas de item com totais" do
#       text = pdf.render
#       expect(text).to include("Produto X")
#       expect(text.scan("%.2f" % (2 * 25.0)).size).to eq 2
#     end
#   end
# end
