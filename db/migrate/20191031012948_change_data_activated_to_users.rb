class ChangeDataActivatedToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :activated, :boolean, default: false
  end
end
