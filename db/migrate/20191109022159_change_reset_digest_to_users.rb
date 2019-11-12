class ChangeResetDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :reset_digest, :text
  end
end
