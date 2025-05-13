require 'prawn'
require 'prawn/table'  # agora existe no load path

class OrderPdf < Prawn::Document
  def initialize(order)
    super(page_size: 'A4', margin: 40)
    @order = order
    header
    order_details
    move_down 20
    order_items_table
  end

  def header
    text "Pedido ##{@order.id}", size: 24, style: :bold, align: :center
    stroke_horizontal_rule
  end

  def order_details
    move_down 10
    text "Cliente: #{@order.company.name}"
    text "Data do Pedido: #{@order.created_at.strftime('%d/%m/%Y %H:%M')}"
  end

  def order_items_table
    move_down 15
    table(item_rows, header: true, row_colors: %w[DDDDDD FFFFFF], width: bounds.width) do
      row(0).font_style = :bold
      columns(2..4).align = :right
    end
  end

  def item_rows
    [['#', 'Produto', 'Quantidade', 'Code', 'Preço Unitário']] +
      @order.order_items.map.with_index(1) do |item, i|
        [
          i,
          item.product,
          item.quantity,
          item.code,
          format_currency(item.price),
        ]
      end
  end

  private

  def format_currency(number)
    "%.2f" % number
  end
end
