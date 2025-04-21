class ApplicationController < ActionController::API
  include Secured
  include Pundit::Authorization
  include Error::ExceptionHandler

  attr_reader :current_user
end
