# frozen_string_literal: true

module UserCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      User.create! @params
    end
  end
end
