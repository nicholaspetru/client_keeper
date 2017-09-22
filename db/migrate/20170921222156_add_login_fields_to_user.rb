class AddLoginFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :username, :string
    add_column :stores, :password, :string
    add_column :stores, :claimed, :boolean, null: false, default: false
  end
end
