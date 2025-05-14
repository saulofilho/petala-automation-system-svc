# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Companies', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/companies/{id}' do
    get 'show a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_show'
      parameter name: :id, in: :path, type: :string
      security [cookie_auth: [], bearer_auth: []]

      context 'When user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'company founded' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            schema schema_with_object(:company, '#/components/schemas/company')

            run_test! do
              expect(json_response[:company][:cnpj]).to be_present
            end
          end

          response 404, 'company not founded' do
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

          response 200, 'company founded' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            schema schema_with_object(:company, '#/components/schemas/company')

            run_test! do
              expect(json_response[:company][:cnpj]).to be_present
            end
          end

          response 404, 'company not founded' do
            let(:id) { 999 }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:id) { company.id }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end
      end

      context 'When user is not logged in' do
        let(:id) { 999 }
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end

    put 'update a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_update'
      parameter name: :id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/company_update' }
      security [cookie_auth: [], bearer_auth: []]

      context 'When user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'company updated' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            let(:payload) do
              {
                company: {
                  name: 'Foo Bar Company',
                  cnpj: Faker::Company.brazilian_company_number,
                  cep: Faker::Address.zip_code,
                  street: Faker::Address.street_name,
                  number: Faker::Address.building_number.to_i,
                  city: Faker::Address.city,
                  state: Faker::Address.state_abbr
                }
              }
            end
            schema schema_with_object(:company, '#/components/schemas/company')

            run_test! do
              expect(json_response[:company][:name]).to eq 'Foo Bar Company'
            end
          end

          response 404, 'company not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                company: {
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

          response 200, 'company updated' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            let(:payload) do
              {
                company: {
                  name: 'Foo Bar Company',
                  cnpj: Faker::Company.brazilian_company_number,
                  cep: Faker::Address.zip_code,
                  street: Faker::Address.street_name,
                  number: Faker::Address.building_number.to_i,
                  city: Faker::Address.city,
                  state: Faker::Address.state_abbr
                }
              }
            end
            schema schema_with_object(:company, '#/components/schemas/company')

            run_test! do
              expect(json_response[:company][:name]).to eq 'Foo Bar Company'
            end
          end

          response 404, 'company not founded' do
            let(:id) { 999 }
            let(:payload) do
              {
                company: {
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
            let(:id) { company.id }
            let(:payload) do
              {
                company: {
                  name: 'Foo Bar Company'
                }
              }
            end
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end
      end

      context 'When user is not logged in' do
        let(:id) { 999 }
        let(:payload) do
          {
            company: {
              name: 'Foo Bar Company'
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

    delete 'destroy a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_destroy'
      parameter name: :id, in: :path, type: :string
      security [cookie_auth: [], bearer_auth: []]

      context 'When user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 204, 'company destroyed' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            run_test!
          end

          response 404, 'company not founded' do
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

          response 204, 'company destroyed' do
            let(:company) { create(:company, user:) }
            let(:id) { company.id }
            run_test!
          end

          response 404, 'company not founded' do
            let(:id) { 999 }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end

          response 403, 'user not owner' do
            let(:other_user) { create(:user) }
            let(:company) { create(:company, user: other_user) }
            let(:id) { company.id }
            schema '$ref' => '#/components/schemas/error_response'
            run_test!
          end
        end
      end

      context 'When user is not logged in' do
        let(:id) { 999 }
        include_context 'with missing jwt authentication'
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end
  end

  path '/v1/users/{user_id}/companies' do
    get 'list companies' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_index'
      parameter name: :user_id, in: :path, type: :string
      security [cookie_auth: [], bearer_auth: []]

      context 'when user is logged in' do
        context 'as admin' do
          let(:user) { create(:user, role: 'admin') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'company founded' do
            let!(:company) { create_list(:company, 3) }
            let!(:user_companies) { create_list(:company, 3, user:) }
            schema schema_with_objects(:companies, '#/components/schemas/company')
            run_test! do
              expect(json_response[:companies].size).to eq 6
            end
          end
        end

        context 'as manager' do
          let(:user) { create(:user, role: 'manager') }
          include_context 'with user authentication' do
            let(:user_id) { user.id }
          end

          response 200, 'company founded' do
            let!(:company) { create_list(:company, 3, user:) }
            schema schema_with_objects(:companies, '#/components/schemas/company')
            run_test! do
              expect(json_response[:companies].size).to eq 3
            end
          end
        end
      end

      context 'when user is not logged in' do
        include_context 'with missing jwt authentication'
        let(:user_id) { 1 }
        response 401, 'invalid session' do
          schema '$ref' => '#/components/schemas/error_response'
          run_test!
        end
      end
    end

    post 'create a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      operationId 'company_create'
      parameter name: :user_id, in: :path, type: :string
      parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/company' }
      security [cookie_auth: [], bearer_auth: []]

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
          schema schema_with_object(:company, '#/components/schemas/company')

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
