class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :token
      t.string :contact_email
      t.boolean :active
      t.timestamps
    end
  end
end
