class CreateUserRankings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_rankings do |t|

      t.timestamps
    end
  end
end
