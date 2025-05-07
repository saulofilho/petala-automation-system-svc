# frozen_string_literal: true

class InvalidCredentialsException < Error::Exception
  def initialize
    super(
      message: 'E-mail ou senha inválidos',
      status_code: :bad_request
    )
  end
end
