class RenameColumnLabelForVotingRounds < ActiveRecord::Migration
  def change
    rename_column :voting_rounds, :label, :public_label
  end
end
