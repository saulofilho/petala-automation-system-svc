# frozen_string_literal: true

# app/controllers/v1/products_controller.rb
module V1
  class OrderItemsController < ApplicationController
    before_action :authenticate_request!
    before_action :set_order, only: %i[index import]
    before_action :set_order_item, only: %i[show update destroy]

    def index
      @order_items = policy_scope(@order.order_items)
      render json: Panko::Response.new(order_items: Panko::ArraySerializer.new(@order_items, each_serializer: OrderItemSerializer)),
             status: :ok
    end

    def show
      authorize @order_item
      render json: { order_item: OrderItemSerializer.new.serialize(@order_item) }, status: :ok
    end

    def create
      order_item = OrderItem.create!(order_item_create_params)
      render json: { order_item: OrderItemSerializer.new.serialize(order_item) }, status: :created
    end

    def update
      authorize @order_item
      @order_item.update!(order_item_update_params)
      render json: { order_item: OrderItemSerializer.new.serialize(@order_item) }, status: :ok
    end

    def destroy
      authorize @order_item
      @order_item.destroy
      head :no_content
    end

    def import
      file = params.require(:file)
      spreadsheet = Roo::Spreadsheet.open(file.path, extension: File.extname(file.original_filename).delete('.'))
      result = ImportOrderItemsService.new(@order, spreadsheet).call

      if result[:errors].empty?
        render json: { imported: result[:imported] }, status: :created
      else
        render json: { imported: result[:imported], errors: result[:errors] }, status: :unprocessable_entity
      end
    end

    private

    def set_order
      @order = Order.find(params[:order_id])
    end

    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def order_item_create_params
      params.require(:order_item).permit(
        :code, :product, :price, :quantity, :ean_code, :total, :order_id
      )
    end

    def order_item_update_params
      params.require(:order_item).permit(
        :code, :product, :price, :quantity, :ean_code, :total
      )
    end
  end
end
