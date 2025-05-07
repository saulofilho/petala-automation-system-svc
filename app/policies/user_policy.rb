# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def create?
    @user.id == @record.id
  end
end
