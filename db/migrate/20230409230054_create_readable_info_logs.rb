class CreateReadableInfoLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :readable_info_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :total_readable_info, null: false, foreign_key: true
      t.boolean :can_read, null: false
      t.timestamps
    end
  end
end
