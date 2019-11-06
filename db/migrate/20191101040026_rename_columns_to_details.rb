class RenameColumnsToDetails < ActiveRecord::Migration[5.1]
  def change
    rename_column :details, :orders_id, :order_id
    rename_column :details, :products_id, :product_id
  end
end
