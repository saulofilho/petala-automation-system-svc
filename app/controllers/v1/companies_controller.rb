# frozen_string_literal: true

module V1
  class CompaniesController < ApplicationController
    before_action :authenticate_request!
    before_action :set_company, only: %i[show update destroy]

    def index
      @companies = policy_scope(Company)
      render json: Panko::Response.new(companies: Panko::ArraySerializer.new(@companies, each_serializer: CompanySerializer)),
             status: :ok
    end

    def show
      authorize @company
      render json: { company: CompanySerializer.new.serialize(@company) }, status: :ok
    end

    def create
      company = Company.create!(company_create_params)
      render json: { company: CompanySerializer.new.serialize(company) }, status: :created
    end

    def update
      authorize @company
      @company.update!(company_update_params)
      render json: { company: CompanySerializer.new.serialize(@company) }, status: :ok
    end

    def destroy
      authorize @company
      @company.destroy
      head :no_content
    end

    private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_create_params
      params.require(:company).permit(:name, :cnpj, :cep, :street, :number, :city, :state, :user_id)
    end

    def company_update_params
      params.require(:company).permit(:name, :cnpj, :cep, :street, :number, :city, :state)
    end
  end
end
