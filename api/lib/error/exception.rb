# frozen_string_literal: true

module Error
  class Exception < StandardError
    attr_reader :id, :message, :status_code, :detail

    def initialize(message: 'Erro inesperado', status_code: :internal_server_error, id: self.class.to_s.underscore,
                   detail: nil)
      @message = message
      @status_code = status_code
      @id = id
      @detail = detail
    end

    def to_json(*_args)
      { error: { id:, message:, detail: } }.to_json
    end

    def json_response(*_args)
      { error: { id:, message: } }.to_json
    end
  end
end
