class CreateSizes < ActiveRecord::Migration[5.1]
  def change
    create_table :sizes do |t|
      t.string :size

      t.timestamps
    end
    add_index :sizes, :size, unique: true
  end
end
