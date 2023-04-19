class CreateComicSites < ActiveRecord::Migration[6.1]
  def change
    create_table :comic_sites do |t|
      t.integer :rakuten_book_id, null: false, foreign_key: true
      t.string :site_name, null: false
      t.timestamps
    end
  end
end
