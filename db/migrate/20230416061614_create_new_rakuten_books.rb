class CreateNewRakutenBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :new_rakuten_books do |t|

      t.timestamps
    end
  end
end
