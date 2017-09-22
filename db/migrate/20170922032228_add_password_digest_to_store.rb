class AddPasswordDigestToStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :password_digest, :string
  end
end
