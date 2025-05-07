# frozen_string_literal: true

module SessionCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      user = User.find_by(email: @params[:email])
      raise InvalidCredentialsException unless user&.authenticate(@params[:password])

      session_token = JsonWebToken.encode(user: { id: user.id })
      { session_token:, user: }
    end
  end
end
