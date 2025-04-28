module V1
  class CompaniesController < ApplicationController
    before_action :authenticate_request!
    before_action :set_user, only: %i[index create]
    before_action :set_company, only: %i[show update destroy]

    def index
      companies = Company.all
      render json: companies, each_serializer: CompanySerializer, status: :ok
    end

    def show
      render json: @company, serializer: CompanySerializer, status: :ok
    end

    def create
      company = Company.new(company_params)
      if company.save
        render json: { company: CompanySerializer.new(company) }, status: :created
      else
        render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
      end
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

    def set_user
      head :forbidden unless params[:user_id].to_i == current_user.id
      @user = current_user
    end

    def set_company
      @company = current_user.companies.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :cnpj, :address)
    end
  end
end
