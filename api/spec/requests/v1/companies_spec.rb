# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Companies', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/users/{user_id}/companies' do
    post 'create a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_create'
      parameter name: :user_id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/company' }

      context 'When user is logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        include_context 'with user authentication' do
          let(:user_id) { user.id }
        end

        response 201, 'company created' do
          let(:payload) do
            {
              company: {
                name: Faker::Company.name,
                cnpj: Faker::Company.brazilian_company_number,
                cep: Faker::Address.zip_code,
                street: Faker::Address.street_name,
                number: Faker::Address.building_number.to_i,
                city: Faker::Address.city,
                state: Faker::Address.state_abbr,
                user_id:
              }
            }
          end
          schema '$ref' => '#/components/schemas/company'
          run_test! do
            expect(json_response[:company][:cnpj]).to be_present
          end
        end

        response 422, 'with invalid params' do
          let(:payload) do
            {
              company: {}
            }
          end
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end

      context 'When user is not logged in' do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:payload) do
          {
            company: {
              name: Faker::Company.name,
              cnpj: Faker::Company.brazilian_company_number,
              cep: Faker::Address.zip_code,
              street: Faker::Address.street_name,
              number: Faker::Address.building_number.to_i,
              city: Faker::Address.city,
              state: Faker::Address.state_abbr,
              user_id:
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
