class CreateComics < ActiveRecord::Migration[6.1]
  def change
    create_table :comics do |t|
      t.integer :rakuten_book_id
      t.timestamps
    end
  end
end
