# frozen_string_literal: true

module V1
  class OrdersController < ApplicationController
    before_action :authenticate_request!
    before_action :set_order, only: %i[show update destroy pdf]

    def index
      @orders = policy_scope(Order)
      render json: Panko::Response.new(orders: Panko::ArraySerializer.new(@orders, each_serializer: OrderSerializer)),
             status: :ok
    end

    def show
      authorize @order
      render json: { order: OrderSerializer.new.serialize(@order) }, status: :ok
    end

    def create
      order = Order.create!(order_create_params)
      render json: { order: OrderSerializer.new.serialize(order) }, status: :created
    end

    def update
      authorize @order
      @order.update!(order_update_params)
      render json: { order: OrderSerializer.new.serialize(@order) }, status: :ok
    end

    def destroy
      authorize @order
      @order.destroy
      head :no_content
    end

    def pdf
      authorize @order
      pdf = OrderPdf.new(@order)
      send_data pdf.render,
                filename: "order_#{@order.id}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_create_params
      params.require(:order).permit(:status, :description, :admin_feedback, :company_id)
    end

    def order_update_params
      params.require(:order).permit(:status, :description, :admin_feedback)
    end
  end
end
