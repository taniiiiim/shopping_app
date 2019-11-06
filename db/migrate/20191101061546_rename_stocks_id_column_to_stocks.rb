class RenameStocksIdColumnToStocks < ActiveRecord::Migration[5.1]
  def change
    rename_column :stocks, :products_id, :product_id
  end
end
