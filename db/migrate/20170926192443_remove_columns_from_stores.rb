class RemoveColumnsFromStores < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :active, :boolean
    remove_column :stores, :contact_email, :string
    remove_column :stores, :claimed, :boolean
  end
end
