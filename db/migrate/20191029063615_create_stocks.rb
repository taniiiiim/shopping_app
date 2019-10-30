class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :products, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
