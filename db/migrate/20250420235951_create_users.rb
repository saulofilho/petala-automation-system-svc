# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :cpf
      t.string :phone
      t.string :role
      t.string :verification_token
      t.datetime :verification_token_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :cpf, unique: true
  end
end
