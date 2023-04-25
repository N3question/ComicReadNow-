class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remaining_total_update_limit, :integer, default: 100
  end
end
