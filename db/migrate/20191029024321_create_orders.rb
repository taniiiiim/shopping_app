class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :users, foreign_key: true
      t.integer :total
      t.string :code
      t.string :address
      t.string :order_digest
      t.boolean :ordered
      t.datetime :ordered_at

      t.timestamps
    end
  end
end
