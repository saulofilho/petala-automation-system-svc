# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role_admin?
        scope.all
      else
        scope.joins(:company).where(companies: { user_id: user.id })
      end
    end
  end

  def index?
    owner? || admin?
  end

  def show?
    owner? || admin?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  def pdf?
    owner? || admin?
  end

  private

  def owner?
    @user.id == @record.company.user.id
  end
end
