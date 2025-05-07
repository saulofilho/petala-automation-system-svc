# frozen_string_literal: true

class EmailNotFoundException < Error::Exception
  def initialize
    super(
      message: 'Este e-mail não está cadastrado',
      status_code: :not_found
    )
  end
end
