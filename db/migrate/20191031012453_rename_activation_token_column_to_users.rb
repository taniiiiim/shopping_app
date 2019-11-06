class RenameActivationTokenColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :activation_token, :activation_digest
    rename_column :users, :reset_token, :reset_digest 
  end
end
