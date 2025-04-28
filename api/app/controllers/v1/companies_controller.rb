# frozen_string_literal: true

module V1
  class CompaniesController < ApplicationController
    before_action :authenticate_request!
    before_action :set_company, only: %i[show update destroy]

    def index
      companies = Company.all
      render json: companies, each_serializer: CompanySerializer, status: :ok
    end

    def show
      render json: @company, serializer: CompanySerializer, status: :ok
    end

    def create
      company = Company.create!(company_params)
      render json: { company: CompanySerializer.new.serialize(company) }, status: :created
    end

    def update
      if @company.update(company_params)
        render json: { company: CompanySerializer.new(@company) }, status: :ok
      else
        render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @company.destroy
      head :no_content
    end

    private

    def set_company
      @company = current_user.companies.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :cnpj, :cep, :street, :number, :city, :state, :user_id)
    end
  end
end
