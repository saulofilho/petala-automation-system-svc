# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Orders', swagger_doc: 'v1/swagger.yaml' do
    path '/v1/orders/{id}/pdf' do
      get 'download pdf' do
        tags 'Orders'
        consumes 'application/json'
        produces 'application/json'
        operationId 'order_show'
        parameter name: :id, in: :path, type: :string
        security [cookie_auth: [], bearer_auth: []]

        context 'when user is logged in' do
          context 'as admin' do
            let(:user) { create(:user, role: 'admin') }
            include_context 'with user authentication' do
              let(:user_id) { user.id }
            end

            response 200, 'pdf was generated' do
              let(:company) { create(:company, user:) }
              let(:order) { create(:order, company:) }
              let(:id) { order.id }
              run_test! do
                expect(response).to have_http_status(:ok)
                expect(response.content_type).to eq "application/pdf"
                expect(response.body.byteslice(0, 4)).to eq "%PDF"
                expect(response.headers["Content-Disposition"])
                  .to match /inline; filename="order_#{order.id}\.pdf"/
              end
            end

            response 404, 'order not founded' do
              let(:id) { 999 }
              schema '$ref' => '#/components/schemas/error_response'
              run_test!
            end
          end

          context 'as manager' do
            let(:user) { create(:user, role: 'manager') }
            include_context 'with user authentication' do
              let(:user_id) { user.id }
            end

            response 200, 'pdf was generated' do
              let(:company) { create(:company, user:) }
              let(:order) { create(:order, company:) }
              let(:id) { order.id }
              run_test! do
                expect(response).to have_http_status(:ok)
                expect(response.content_type).to eq "application/pdf"
                expect(response.body.byteslice(0, 4)).to eq "%PDF"
                expect(response.headers["Content-Disposition"])
                  .to match /inline; filename="order_#{order.id}\.pdf"/
              end
            end

            response 404, 'order not founded' do
              let(:id) { 999 }
              schema '$ref' => '#/components/schemas/error_response'
              run_test!
            end

            response 403, 'user not owner' do
              let(:other_user) { create(:user) }
              let(:company) { create(:company, user: other_user) }
              let(:order) { create(:order, company: company) }
              let(:id) { order.id }
              schema '$ref' => '#/components/schemas/error_response'
              run_test!
            end
          end
        end

        context 'when user is not logged in' do
          let(:id) { 999 }
          include_context 'with missing jwt authentication'
          response 401, 'invalid session' do
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end
      end
  end
end
