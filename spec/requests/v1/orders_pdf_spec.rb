# spec/requests/v1/orders_pdf_spec.rb
require 'rails_helper'

# RSpec.describe "GET /v1/orders/:id/pdf", type: :request do
#   let(:user)    { create(:user) }
#   let(:order)   { create(:order) }
#   let(:token)   { JwtService.encode(user_id: user.id) }
#   let(:cookies) { { session_token: token } }

#   before do
#     allow_any_instance_of(ApplicationController)
#       .to receive(:authenticate_request!)
#       .and_return(true)
#     allow_any_instance_of(ApplicationController)
#       .to receive(:current_user)
#       .and_return(user)
#   end

#   it "retorna status 200 e um PDF válido" do
#     get "/v1/orders/#{order.id}/pdf", headers: { "Cookie" => cookie_header(cookies) }

#     expect(response).to have_http_status(:ok)
#     expect(response.content_type).to eq "application/pdf"
#     expect(response.body.byteslice(0, 4)).to eq "%PDF"
#     expect(response.headers["Content-Disposition"])
#       .to match /inline; filename="order_#{order.id}\.pdf"/
#   end

#   private

#   def cookie_header(hash)
#     hash.map { |k, v| "#{k}=#{v}" }.join("; ")
#   end
# end
