# frozen_string_literal: true

class OrderItemPolicy < ApplicationPolicy
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

  private

  def owner?
    @user.id == @record.order.company.user.id
  end
end
