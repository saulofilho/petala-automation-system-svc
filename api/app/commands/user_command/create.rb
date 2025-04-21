# frozen_string_literal: true

module UserCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      user = User.create! @params
      session_token = JsonWebToken.encode(user: { id: user.id })
      user.generate_validation_token
      { session_token:, user: }
    end
  end
end
