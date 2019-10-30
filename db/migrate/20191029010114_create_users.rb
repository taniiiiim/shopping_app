class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :real_name
      t.string :email
      t.string :password_digest
      t.string :gender
      t.date :birthdate
      t.string :code
      t.string :address
      t.string :remember_digest
      t.boolean :activated
      t.string :activation_token
      t.datetime :activated_at
      t.datetime :reset_token
      t.datetime :reset_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
