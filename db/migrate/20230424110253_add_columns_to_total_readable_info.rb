class AddColumnsToTotalReadableInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :comics, :remaining_one_comic_update_limit, :integer, default: 1
  end
end
