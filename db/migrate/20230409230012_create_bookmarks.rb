class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comic, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
      # 2つのカラムにまたがる設定のため、別途設定のための文書を記述してあげる必要
      add_index :bookmarks, [:user_id, :comic_id], unique: true
  end
end
