class CreateComicComicSites < ActiveRecord::Migration[6.1]
  def change
    create_table :comic_comic_sites do |t|
      t.references :comic, null: false, foreign_key: true
      t.references :comic_site, null: false, foreign_key: true
      t.references :readable_info, null: false, foreign_key: true
      t.timestamps
    end
  end
end
