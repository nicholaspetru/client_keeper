class RemoveBalanceFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :balance, :integer
  end
end
