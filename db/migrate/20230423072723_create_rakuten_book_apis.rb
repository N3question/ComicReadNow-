class CreateRakutenBookApis < ActiveRecord::Migration[6.1]
  def change
    create_table :rakuten_book_apis do |t|
      t.bigint "isbn", null: false
      t.string "title", null: false
      t.string "large_image_url", null: false
      t.timestamps
    end
  end
end
