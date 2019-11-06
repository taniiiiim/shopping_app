class RemoveForeignKeyFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :stock_id, :integer
  end
end
