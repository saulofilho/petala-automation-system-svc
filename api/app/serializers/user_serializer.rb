# frozen_string_literal: true

class UserSerializer < Panko::Serializer
  attributes :id, :email, :name, :cpf, :phone, :role
end
