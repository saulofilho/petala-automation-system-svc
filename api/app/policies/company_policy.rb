# frozen_string_literal: true

class CompanyPolicy < ApplicationPolicy
  def index?
    @user.id == @record.id
  end

  def show?
    @user.id == @record.addressable.user.id
  end

  def update?
    @user.id == @record.addressable.user.id
  end

  def destroy?
    @user.id == @record.addressable.user.id
  end
end
