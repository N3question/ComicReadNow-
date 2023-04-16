class CreateSaleRakutenBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :sale_rakuten_books do |t|

      t.timestamps
    end
  end
end
