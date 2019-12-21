class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :fullname
      t.string :email
      t.integer :waist
      t.integer :hips
      t.integer :chest
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
