class AddColumnsToTotalReadableInfos < ActiveRecord::Migration[6.1]
  def change
    add_column :total_readable_infos, :can_read, :boolean, null: false, default: 0
    add_column :total_readable_infos, :version, :integer, null: false, default: 0
  end
end
