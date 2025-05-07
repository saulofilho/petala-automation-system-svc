# frozen_string_literal: true

require 'net/http'
require 'uri'

class JsonWebToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Settings.secret_key, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, Settings.secret_key, true, { algorithm: 'HS256' }).first
  end
end
