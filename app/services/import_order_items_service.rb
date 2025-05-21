# frozen_string_literal: true

class ImportOrderItemsService
  HEADER_MAP = {
    'Código' => 'code',
    'Produto' => 'product',
    'Preço' => 'price',
    'Qtd' => 'quantity',
    'Total' => 'total',
    'EAN' => 'ean_code'
  }.freeze

  def initialize(order, workbook)
    @order = order
    @sheet = workbook.respond_to?(:sheet) ? workbook.sheet(0) : workbook

    raw_header = @sheet.row(1).map(&:to_s)
    @header    = raw_header.map { |h| HEADER_MAP[h.strip] || h.parameterize.underscore }

    @imported = []
    @errors   = []
  end

  def call
    (2..@sheet.last_row).each do |i|
      row_vals = @sheet.row(i)
      next if row_vals.all?(&:blank?)

      row_hash = Hash[@header.zip(row_vals.map(&:to_s))]

      item_attrs = {
        code: row_hash['code'].presence || '0',
        product: row_hash['product'].presence || 'Produto',
        price: row_hash['price'].presence ? row_hash['price'] : '0',
        quantity: row_hash['quantity'].present? ? row_hash['quantity'].to_i : 0,
        total: row_hash['total'].presence ? row_hash['total'] : '0',
        ean_code: row_hash['ean_code'].presence || '0'
      }

      item = @order.order_items.build(item_attrs)

      if item.save
        @imported << item
      else
        @errors << { row: i, messages: item.errors.full_messages }
      end
    end

    { imported: @imported.size, errors: @errors }
  end
end
