# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :admin_feedback, default: nil
      t.string :status, default: 'pending'
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
