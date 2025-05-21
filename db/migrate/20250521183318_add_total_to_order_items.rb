# frozen_string_literal: true

class AddTotalToOrderItems < ActiveRecord::Migration[8.0]
  def up
    change_column :order_items, :code,     :string,  null: false, default: '0'
    change_column :order_items, :product,  :string,  null: false, default: 'Produto'
    change_column :order_items, :ean_code, :string,  null: false, default: '0'
    change_column :order_items, :price,    :string, null: false, default: '0'
    change_column :order_items, :quantity, :integer, null: false, default: 0
    add_column    :order_items, :total,    :string, null: false, default: '0'
  end

  def down
    remove_column :order_items, :total
    change_column :order_items, :quantity, :integer, null: true, default: nil
    change_column :order_items, :price,    :string, null: true, default: nil
    change_column :order_items, :ean_code, :string,  null: true, default: nil
    change_column :order_items, :product,  :string,  null: true, default: nil
    change_column :order_items, :code,     :string,  null: true, default: nil
  end
end
