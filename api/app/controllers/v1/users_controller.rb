# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: %i[me change_password]

    def create
      command = UserCommand::Create.call(user_params)
      response.set_cookie(:session_token, value: command.result[:session_token], path: '/', httponly: true,
                                          expires: 24.hours.from_now)

      render json: { user: UserSerializer.new.serialize(command.result[:user]) }, status: :created
    end

    def change_password
      UserCommand::ChangePassword.call(change_password_params, current_user)

      head :no_content
    end

    def me
      render json: @current_user, status: :ok, serializer: UserSerializer
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :name, :cpf, :phone, :role)
    end

    def destroy_params
      params.permit(:id)
    end

    def change_password_params
      params.require(:new_password)
    end
  end
end
