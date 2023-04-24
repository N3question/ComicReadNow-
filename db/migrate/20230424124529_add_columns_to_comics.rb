class AddColumnsToComics < ActiveRecord::Migration[6.1]
  def change
    add_column :comics, :can_read, :integer, null: false, default: 0
    add_column :comics, :can_not_read, :integer, null: false, default: 0
    add_column :comics, :version, :integer, null: false, default: 0
  end
end
