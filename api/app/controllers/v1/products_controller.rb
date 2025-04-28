# app/controllers/v1/products_controller.rb
module V1
  class ProductsController < ApplicationController
    before_action :authenticate_request!
    before_action :set_order, only: %i[index create]
    before_action :set_product, only: %i[show update destroy]

    def index
      @products = @order.products
      render json: @products
    end

    def create
      @product = @order.products.new(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render json: @product
    end

    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      head :no_content
    end

    private

    def set_order
      @order = Order.find(params[:order_id])
      head :forbidden unless @order.company.user_id == current_user.id
    end

    def set_product
      @product = Product.find(params[:id])
      head :forbidden unless @product.order.company.user_id == current_user.id
    end

    def product_params
      params.require(:product).permit(
        :code, :name, :price, :quantity, :total, :uuid, :ean
      )
    end
  end
end
