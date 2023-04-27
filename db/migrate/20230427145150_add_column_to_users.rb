class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :update_count, :integer, null: false, default: 0
  end
end
