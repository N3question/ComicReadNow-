class ChangeTotalReadableInfosToReadJudgements < ActiveRecord::Migration[6.1]
  def change
    rename_table :total_readable_infos ,:read_judgements
  end
end
