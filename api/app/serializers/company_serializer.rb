class CompanySerializer < Panko::Serializer
  attributes :id, :name, :cnpj, :cep, :street, :number, :city, :state, :user_id
end
