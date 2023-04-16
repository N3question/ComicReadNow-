class CreateRakutenBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :rakuten_books, primary_key: %w(isbn) do |t|
      t.bigint :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.string :image_url, null: false
      t.timestamps
    end
  end
end
