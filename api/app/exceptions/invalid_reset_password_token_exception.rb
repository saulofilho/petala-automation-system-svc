# frozen_string_literal: true

class InvalidResetPasswordTokenException < Error::Exception
  def initialize
    super(
      message: 'O token fornecido é inválido ou está expirado',
      status_code: :bad_request
    )
  end
end
