class CreateReadableInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :readable_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comic, null: false, foreign_key: true
      t.timestamps
    end
  end
end
