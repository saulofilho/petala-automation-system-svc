# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.string :code
      t.string :product
      t.float :price
      t.integer :quantity
      t.string :ean_code
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
