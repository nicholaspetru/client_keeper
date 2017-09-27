class AddStatusToCard < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :status, :string
  end
end
