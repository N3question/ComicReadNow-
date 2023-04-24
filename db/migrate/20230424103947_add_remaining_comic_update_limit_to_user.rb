class AddRemainingComicUpdateLimitToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remaining_comic_update_limit, :integer, default: 50
  end
end
