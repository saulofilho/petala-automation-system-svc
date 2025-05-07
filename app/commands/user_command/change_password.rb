# frozen_string_literal: true

module UserCommand
  class ChangePassword
    prepend SimpleCommand

    def initialize(params, current_user)
      @new_password = params
      @user = current_user
    end

    def call
      @user.update!(password: @new_password)
    end
  end
end
