class CreateComicSites < ActiveRecord::Migration[6.1]
  def change
    create_table :comic_sites do |t|
      t.integer :site_id
      t.integer :comic_id

      t.timestamps
    end
  end
end
