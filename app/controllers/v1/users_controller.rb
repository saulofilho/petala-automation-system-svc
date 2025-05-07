# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: %i[me change_password update destroy]
    before_action :set_user, only: %i[update destroy]

    def create
      command = UserCommand::Create.call(user_params)
      response.set_cookie(
        :session_token,
        value: command.result[:session_token],
        path: '/',
        httponly: true,
        expires: 24.hours.from_now
      )
      render json: { user: UserSerializer.new.serialize(command.result[:user]) }, status: :created
    end

    def me
      render json: { user: UserSerializer.new.serialize(@current_user) }, status: :ok
    end

    def update
      if @user.update(user_params)
        render json: { user: UserSerializer.new.serialize(@user) }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      head :no_content
    end

    def change_password
      if @current_user.update(password: change_password_params)
        head :no_content
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def change_password
      UserCommand::ChangePassword.call({ new_password: change_password_params }, @current_user)
      head :no_content
    end

    # def change_password
    #   if current_user.update(password_params)
    #     head :no_content
    #   else
    #     render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    #   end
    # end

    private

    def set_user
      @user = User.find(params[:id])
      head :forbidden unless @user == current_user
    end

    def user_params
      params.require(:user).permit(:email, :password, :name, :cpf, :phone, :role)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
