class CreateGenders < ActiveRecord::Migration[5.1]
  def change
    create_table :genders do |t|
      t.string :gender

      t.timestamps
    end
    add_index :genders, :gender, unique: true
  end
end
