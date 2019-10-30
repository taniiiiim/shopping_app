class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :gender, foreign_key: true
      t.references :category, foreign_key: true
      t.references :size, foreign_key: true
      t.integer :price
      t.string :abstract

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
