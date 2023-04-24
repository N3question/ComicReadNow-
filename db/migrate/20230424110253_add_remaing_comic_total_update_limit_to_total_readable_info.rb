class AddRemaingComicTotalUpdateLimitToTotalReadableInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :total_readable_infos, :remaining_one_comic_update_limit, :integer, default: 10
  end
end
