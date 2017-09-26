class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :store_token
      t.string :user_token
      t.timestamps
    end
  end
end
