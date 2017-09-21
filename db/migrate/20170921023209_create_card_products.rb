class CreateCardProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :card_products do |t|
      t.string :name
      t.string :token
      t.boolean :active
      t.timestamps
    end
  end
end
