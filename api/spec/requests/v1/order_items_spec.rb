# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::OrderItems', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/order_items/{id}' do
    get 'show an order item' do
      tags 'OrderItems'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_item_show'
      parameter name: :id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order item founded' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            schema '$ref' => '#/components/schemas/order_item'
            run_test! do
              expect(json_response[:order_item][:code]).to be_present
            end
          end

          response 404, 'order_item not founded' do
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

          response 200, 'order item founded' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            schema '$ref' => '#/components/schemas/order_item'
            run_test! do
              expect(json_response[:order_item][:code]).to be_present
            end
          end

          response 404, 'order_item not founded' do
            let(:id) { 999 }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:order) { create(:order, company: company) }
            let(:order_item) { create(:order_item, order: order) }
            let(:id) { order_item.id }
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

    put 'update an order item' do
      tags 'OrderItems'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_item_update'
      parameter name: :id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/order_item_update' }

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order item updated' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            let(:payload) do
              {
                order_item: {
                  code: '007'
                }
              }
            end
            schema '$ref' => '#/components/schemas/order_item'
            run_test! do
              expect(json_response[:order_item][:code]).to eq '007'
            end
          end

          response 404, 'order item not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                order_item: {
                  code: '007'
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

          response 200, 'order item updated' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            let(:payload) do
              {
                order_item: {
                  code: '007'
                }
              }
            end
            schema '$ref' => '#/components/schemas/order_item'
            run_test! do
              expect(json_response[:order_item][:code]).to eq '007'
            end
          end

          response 404, 'order item not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                order_item: {
                  code: '007'
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
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            let(:payload) do
              {
                order_item: {
                  name: '007'
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
            order_item: {
              name: '007'
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

    delete 'destroy an order item' do
      tags 'OrderItems'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_item_destroy'
      parameter name: :id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 204, 'order_item destroyed' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            run_test!
          end

          response 404, 'order_item not founded' do
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

          response 204, 'order item destroyed' do
            let(:company) { create(:company, user:) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
            run_test!
          end

          response 404, 'order item not founded' do
            let(:id) { 999 }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:order) { create(:order, company:) }
            let(:order_item) { create(:order_item, order:) }
            let(:id) { order_item.id }
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

  path '/v1/orders/{order_id}/order_items' do
    get 'list order items' do
      tags 'Order Items'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_items_index'
      parameter name: :order_id, in: :path, type: :string

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'order founded' do
            let(:company) { create(:company) }
            let(:user_company) { create(:company, user:) }
            let(:order) { create(:order, company: user_company) }
            let(:user_order) { create(:order, company:) }
            let(:order_id) { order.id }
            let!(:order_item) { create_list(:order_item, 3, order:) }
            let!(:user_order_items) { create_list(:order_item, 3, order: user_order) }
            schema schema_with_objects(:order_items, '#/components/schemas/order_item')
            run_test! do
              expect(json_response[:order_items].size).to eq 6
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
            let(:order) { create(:order, company:) }
            let(:order_id) { order.id }
            let!(:order_item) { create_list(:order_item, 3, order:) }
            schema schema_with_objects(:order_items, '#/components/schemas/order_item')
            run_test! do
              expect(json_response[:order_items].size).to eq 3
            end
          end
        end
      end

      context 'when user is not logged in' do
        let(:order_id) { 1 }
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end

    post 'create a order item' do
      tags 'OrderItems'
      consumes 'application/json'
      produces 'application/json'
      operationId 'order_item_create'
      parameter name: :order_id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/order_item' }

      context 'when user is logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        include_context 'with user authentication' do
          let(:user_id) { user.id }
        end

        response 201, 'order item created' do
          let(:company) { create(:company, user:) }
          let(:order) { create(:order, company:) }
          let(:order_id) { order.id }
          let(:payload) do
            {
              order_item: {
                code: Faker::Code.unique.asin,
                product: Faker::Commerce.product_name,
                price: Faker::Commerce.price(range: 10.0..100.0),
                quantity: 10,
                ean_code: Faker::Code.ean,
                order_id: order.id
              }
            }
          end
          schema '$ref' => '#/components/schemas/order_item'
          run_test! do
            expect(json_response[:order_item][:code]).to be_present
          end
        end

        response 422, 'with invalid params' do
          let(:order_id) { 1 }
          let(:payload) do
            {
              order_item: {}
            }
          end
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end

      context 'when user is not logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:order_id) { 1 }
        let(:payload) do
          {
            order_item: {
              code: '007'
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
