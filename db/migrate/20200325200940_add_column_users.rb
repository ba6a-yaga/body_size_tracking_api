class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :height, :integer
    add_column :users, :arms, :integer
    add_column :users, :head, :integer
    add_column :users, :waist_to_top, :integer
    add_column :users, :waist_to_bottom, :integer
  end
end
