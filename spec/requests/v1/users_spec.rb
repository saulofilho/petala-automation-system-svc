# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::User', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/users' do
    post 'create a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      operationId 'user_create'
      parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/create_user' }

      context 'when create a user' do
        response 201, 'user created' do
          schema schema_with_object(:user, '#/components/schemas/user')
          let(:user) do
            {
              user: {
                email: 'foobar@gmail.com',
                password: '@Teste123@',
                name: 'Foo Bar',
                cpf: '12345678900',
                phone: '1199990000',
                role: 'admin'
              }
            }
          end
          run_test! do
            expect(cookies[:session_token]).to be_present
          end
        end

        response 422, 'invalid resource' do
          schema '$ref' => '#/components/schemas/error_response'

          context 'when password is invalid' do
            let(:user) do
              {
                user: {
                  email: 'foobar@gmail.com',
                  password: '12345678',
                  name: 'Foo Bar',
                  cpf: '12345678900',
                  phone: '1199990000',
                  role: 'promoter'
                }
              }
            end

            run_test! do
              expect(json_response.error.message).to eql 'Validation failed: Password precisa ter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caracter especial'
            end
          end

          context 'when email already exists' do
            before do
              create(:user, email: 'foobar@gmail.com')
            end

            let(:user) do
              {
                user: {
                  email: 'foobar@gmail.com',
                  password: '@Teste123@',
                  name: 'Foo Bar',
                  cpf: '12345678900',
                  phone: '1199990000',
                  role: 'admin'
                }
              }
            end

            run_test! do
              expect(json_response.error.message).to eql 'Validation failed: Email has already been taken'
            end
          end
        end

        context 'when create an admin user' do
          response 201, 'user created' do
            schema schema_with_object(:user, '#/components/schemas/user')

            let(:user) do
              {
                user: {
                  email: 'foobar@gmail.com',
                  password: 'Teste@123',
                  name: 'Foo Bar',
                  cpf: '12345678900',
                  phone: '1199990000',
                  role: 'manager'
                }
              }
            end

            run_test! do
              expect(cookies[:session_token]).to be_present
              expect(User.find_by(email: 'foobar@gmail.com').role).to eq('manager')
            end
          end
        end
      end
    end
  end

  path '/v1/users/me' do
    get 'show current user info' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      operationId 'user_me'
      security [cookie_auth: [], bearer_auth: []]

      response 200, 'valid session' do
        schema schema_with_object(:user, '#/components/schemas/user_response')
        let(:user) { create(:user, role: 'admin') }

        include_context 'with user authentication' do
          let(:user_id) { user.id }
        end

        run_test! do
          expect(json_response.keys).to eql([:user])
        end
      end

      response 401, 'invalid session' do
        schema '$ref' => '#/components/schemas/error_response'

        include_context 'with missing jwt authentication'

        run_test!
      end
    end
  end

  # path '/v1/users/change_password' do
  #   put 'Change users password' do
  #     tags 'Users'
  #     consumes 'application/json'
  #     produces 'application/json'
  #     parameter name: :payload, in: :body, schema: { '$ref' => '#/components/schemas/change_password' }
  #     security [cookie_auth: [], bearer_auth: []]
  #     operationId 'user_change_password'

  #     let(:payload) { { new_password: 'Teste@123' } }
  #     let(:user) { create(:user) }

  #     context 'When user is logged in' do
  #       include_context 'with user authentication' do
  #         let(:user_id) { user.id }
  #       end

  #       response 204, 'valid session' do
  #         run_test! do
  #           user.reload
  #           expect(user.authenticate('Teste@123')).to eq(user)
  #         end
  #       end

  #       response 422, 'invalid resource' do
  #         schema '$ref' => '#/components/schemas/error_response'

  #         let(:payload) { { new_password: '12345678' } }

  #         let(:response_body) do
  #           {
  #             error:
  #               {
  #                 id: 'active_record/record_invalid',
  #                 message: 'Password precisa ter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caracter especial'
  #               }
  #           }
  #         end

  #         run_test! do
  #           expect(json_response).to eql response_body
  #         end
  #       end
  #     end

  #     response 401, 'When user is not logged in' do
  #       schema '$ref' => '#/components/schemas/error_response'

  #       include_context 'with missing jwt authentication'

  #       run_test!
  #     end
  #   end
  # end
end
