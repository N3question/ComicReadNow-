class CreateReadJudgement < ActiveRecord::Migration[6.1]
  def change
    create_table :read_judgements do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.integer :comic_id, null: false, foreign_key: true
      t.boolean :can_read
      t.integer :version, null: false, default: 0

      t.timestamps
    end
  end
end
