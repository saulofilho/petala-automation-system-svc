# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Orders', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/orders/{id}' do
    get 'show an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_show'
      parameter name: :id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order founded' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            schema '$ref' => '#/components/schemas/order'
            run_test! do
              expect(json_response[:order][:name]).to be_present
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

          response 200, 'order founded' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            schema '$ref' => '#/components/schemas/order'
            run_test! do
              expect(json_response[:order][:name]).to be_present
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

    put 'update an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_update'
      parameter name: :id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/order_update' }

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order updated' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            let(:payload) do
              {
                order: {
                  name: 'Foo Bar Order'
                }
              }
            end
            schema '$ref' => '#/components/schemas/order'
            run_test! do
              expect(json_response[:order][:name]).to eq 'Foo Bar Order'
            end
          end

          response 404, 'order not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                order: {
                  name: 'Foo Bar Company'
                }
              }
            end
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end

        context 'as manager' do
          let(:user) { create(:user, role: 'manager') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order updated' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            let(:payload) do
              {
                order: {
                  name: 'Foo Bar Order'
                }
              }
            end
            schema '$ref' => '#/components/schemas/order'
            run_test! do
              expect(json_response[:order][:name]).to eq 'Foo Bar Order'
            end
          end

          response 404, 'order not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                order: {
                  name: 'Foo Bar Company'
                }
              }
            end
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            let(:payload) do
              {
                order: {
                  name: 'Foo Bar Order'
                }
              }
            end
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end
      end

      context 'when user is not logged in' do
        let(:id) { 999 }
        let(:payload) do
          {
            order: {
              name: 'Foo Bar Order'
            }
          }
        end
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end

    delete 'destroy an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_destroy'
      parameter name: :id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 204, 'order destroyed' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            run_test!
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

          response 204, 'order destroyed' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:id) { order.id }
            run_test!
          end

          response 404, 'order not founded' do
            let(:id) { 999 }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:order) { create(:order, company:) }
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

  path '/v1/companies/{company_id}/orders' do
    get 'list orders' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_index'
      parameter name: :company_id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order founded' do
            let(:company) { create(:company) }
            let(:user_company) { create(:company, user:) }
            let(:company_id) { company.id }
            let!(:order) { create_list(:order, 3, company:) }
            let!(:user_orders) { create_list(:order, 3, company: user_company) }
            schema schema_with_objects(:orders, '#/components/schemas/order')
            run_test! do
              expect(json_response[:orders].size).to eq 6
            end
          end
        end

        context 'as manager' do
          let(:user) { create(:user, role: 'manager') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order founded' do
            let(:company) { create(:company, user:) }
            let(:company_id) { company.id }
            let!(:order) { create_list(:order, 3, company:) }
            schema schema_with_objects(:orders, '#/components/schemas/order')
            run_test! do
              expect(json_response[:orders].size).to eq 3
            end
          end
        end
      end

      context 'when user is not logged in' do
        let(:company_id) { 999 }
        let(:id) { 999 }
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end

    post 'create a order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_create'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/order' }

      context 'when user is logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        include_context 'with user authentication' do
          let(:user_id) { user.id }
        end

        response 201, 'order created' do
          let(:company) { create(:company, user:) }
          let(:company_id) { company.id }
          let(:payload) do
            {
              order: {
                name: 'Orçamento de Pedido',
                company_id: company.id
              }
            }
          end
          schema '$ref' => '#/components/schemas/order'
          run_test! do
            expect(json_response[:order][:name]).to be_present
          end
        end

        response 422, 'with invalid params' do
          let(:company_id) { 1 }
          let(:payload) do
            {
              order: {}
            }
          end
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end

      context 'when user is not logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:company_id) { 1 }
        let(:payload) do
          {
            order: {
              name: 'Orçamento de Pedido'
            }
          }
        end
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end
  end
end
