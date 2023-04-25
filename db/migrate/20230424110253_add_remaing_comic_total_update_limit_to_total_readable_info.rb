class AddRemaingComicTotalUpdateLimitToTotalReadableInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :comics, :remaining_one_comic_update_limit, :integer, default: 10
  end
end
