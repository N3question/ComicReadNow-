class CreateComics < ActiveRecord::Migration[6.1]
  def change
    create_table :comics do |t|
      t.bigint :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.string :author_kana, null: false
      t.string :publisher_name, null: false
      t.string :sales_date, null: false
      t.string :large_image_url, null: false
      t.timestamps
    end
  end
end
