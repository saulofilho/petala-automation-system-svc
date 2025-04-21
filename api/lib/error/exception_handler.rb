# frozen_string_literal: true

module Error
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError, with: :handle_exception
    end

    private

    ERROR_STATUS_CODE_MAPPING = {
      ActionController::ParameterMissing => :unprocessable_entity,
      ActiveRecord::RecordNotFound => :not_found,
      ActiveRecord::RecordInvalid => :unprocessable_entity,
      Pundit::NotAuthorizedError => :forbidden,
      JWT::VerificationError => :unauthorized,
      JWT::DecodeError => :unauthorized,
      JWT::ExpiredSignature => :unauthorized,
      ArgumentError => :unprocessable_entity,
      NoMethodError => :internal_server_error,
      AbstractController::ActionNotFound => :not_found
    }.freeze

    def handle_exception(error)
      exception = parse_error(error)
      report_error(exception)
      render_error(exception)
    end

    def parse_error(exception)
      if exception.is_a?(Error::Exception)
        exception
      else
        mapped_status = ERROR_STATUS_CODE_MAPPING[exception.class]
        status_code = if mapped_status
                        mapped_status
                      elsif exception.respond_to?(:status_code)
                        exception.status_code
                      else
                        :internal_server_error
                      end
        Error::Exception.new(id: exception.class.to_s.underscore, status_code:, message: exception.message,
                             detail: exception.full_message)
      end
    end

    def report_error(exception)
      Rails.logger.error(exception.to_json)
    end

    def render_error(exception)
      render json: exception.json_response, status: exception.status_code
    end
  end
end
