class AddRemaingComicTotalUpdateLimitToTotalReadableInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :total_readable_infos, :remaining_comic_total_update_limit, :integer, default: 50
  end
end
