class CreateCanReadJudgements < ActiveRecord::Migration[6.1]
  def change
    create_table :can_read_judgements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :readable_info, null: false, foreign_key: true
      t.boolean :can_read, null: false
      t.timestamps
    end
  end
end
