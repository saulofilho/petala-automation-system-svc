class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :cnpj
      t.string :cep
      t.string :street
      t.integer :number
      t.string :city
      t.string :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :companies, :cnpj, unique: true
  end
end
