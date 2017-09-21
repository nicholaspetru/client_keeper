class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :token
      t.integer :amount
      t.string :state
      t.string :type
      t.string :user_token
      t.string :business_token
      t.string :card_token
      t.timestamps
    end
  end
end
