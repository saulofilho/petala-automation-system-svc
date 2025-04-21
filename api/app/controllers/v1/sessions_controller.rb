# frozen_string_literal: true

module V1
  class SessionsController < ApplicationController
    before_action :authenticate_request!, only: %i[destroy]

    def create
      command = SessionCommand::Create.call(session_params)
      response.set_cookie(:session_token, value: command.result[:session_token], path: '/', httponly: true,
                                          expires: 24.hours.from_now)

      render json: { user: UserSerializer.new.serialize(command.result[:user]) }, status: :created
    end

    def destroy
      response.delete_cookie(:session_token, path: '/')

      head :no_content
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
