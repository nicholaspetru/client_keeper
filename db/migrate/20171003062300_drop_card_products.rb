class DropCardProducts < ActiveRecord::Migration[5.1]
  def change
    drop_table :card_products
  end
end
