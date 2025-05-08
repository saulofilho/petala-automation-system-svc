# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  private

  def authenticate_request!
    @current_user ||= User.eager_load(:companies).find(auth_session_user_id) if auth_token
  end

  def http_token
    return request.cookies['session_token'] if request.cookies['session_token'].present?

    request.headers['Authorization'].split.last if request.headers['Authorization'].present?
  end

  def auth_token
    JsonWebToken.decode(http_token)
  end

  def auth_session_user_id
    auth_token.dig('user', 'id')
  end
end
