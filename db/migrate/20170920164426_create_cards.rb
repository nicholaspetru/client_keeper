class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :token
      t.string :user_token
      t.string :card_product_token
      t.timestamps
    end
  end
end
