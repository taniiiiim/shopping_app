class CreateDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :details do |t|
      t.references :orders, foreign_key: true
      t.references :products, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
