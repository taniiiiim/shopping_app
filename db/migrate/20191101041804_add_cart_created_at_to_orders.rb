class AddCartCreatedAtToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :cart_created_at, :datetime
  end
end
