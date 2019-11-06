class AddStockIdColumnToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :stock_id, :integer
  end
end
